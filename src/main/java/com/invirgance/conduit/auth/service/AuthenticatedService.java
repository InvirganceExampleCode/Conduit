package com.invirgance.conduit.auth.service;

import com.invirgance.convirgance.ConvirganceException;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.web.http.HttpRequest;
import com.invirgance.convirgance.web.http.HttpResponse;
import com.invirgance.convirgance.web.service.Processable;
import com.invirgance.convirgance.web.service.Routable;
import com.invirgance.convirgance.web.service.Service;
import com.invirgance.convirgance.web.validation.ValidationException;
import com.invirgance.convirgance.wiring.annotation.Wiring;

@Wiring("AuthenticatedService")
public class AuthenticatedService implements Service, Processable, Routable
{
    private Service service;
    private String loginPath = "/auth/login";
    private boolean redirectToLogin = true;

    public Service getService() { return service; }
    public void setService(Service service) { this.service = service; }
    public String getLoginPath() { return loginPath; }
    public void setLoginPath(String loginPath) { this.loginPath = loginPath; }
    public boolean isRedirectToLogin() { return redirectToLogin; }
    public void setRedirectToLogin(boolean redirectToLogin) { this.redirectToLogin = redirectToLogin; }

    private boolean isAuthenticated(HttpRequest request)
    {
        return request.getSession().getAttribute("currentUserId") != null;
    }

    private void requireAuthentication(HttpRequest request)
    {
        if(!isAuthenticated(request)) throw new ValidationException("You must sign in to perform this action.");
    }

    @Override
    public Service getDestinationService(HttpRequest request)
    {
        requireAuthentication(request);

        if(service instanceof Routable) return ((Routable)service).getDestinationService(request);
        
        return service;
    }

    @Override
    public Iterable<JSONObject> process(HttpRequest request)
    {
        requireAuthentication(request);
        
        if(!(service instanceof Processable)) throw new ConvirganceException("The wrapped service does not implement Processable.");
        
        return ((Processable)service).process(request);
    }

    @Override
    public void execute(HttpRequest request, HttpResponse response)
    {
        if(!isAuthenticated(request))
        {
            if(redirectToLogin) response.sendRedirect(request.getContextPath() + loginPath);
            else response.sendError(401, "Authentication required");
            
            return;
        }

        service.execute(request, response);
    }
}
