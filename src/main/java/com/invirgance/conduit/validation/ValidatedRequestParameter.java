package com.invirgance.conduit.validation;

import com.invirgance.convirgance.web.http.HttpRequest;
import com.invirgance.convirgance.web.parameter.Parameter;
import com.invirgance.convirgance.web.validation.ValidationException;
import com.invirgance.convirgance.wiring.annotation.Wiring;

@Wiring("ValidatedRequestParameter")
public class ValidatedRequestParameter implements Parameter
{
    private String name;
    private String label;
    private boolean required = true;
    private Integer maxLength;
    private String regex;

    @Override
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }
    public boolean isRequired() { return required; }
    public void setRequired(boolean required) { this.required = required; }
    public Integer getMaxLength() { return maxLength; }
    public void setMaxLength(Integer maxLength) { this.maxLength = maxLength; }
    public String getRegex() { return regex; }
    public void setRegex(String regex) { this.regex = regex; }

    private String displayName()
    {
        if(label != null && !label.isBlank()) return label;
        return name;
    }

    @Override
    public Object getValue(HttpRequest request)
    {
        String value = request.getParameter(name);

        if(required && (value == null || value.isBlank())) throw new ValidationException(displayName() + " is required.");
        if(value != null && maxLength != null && value.length() > maxLength) throw new ValidationException(displayName() + " must not exceed " + maxLength + " characters.");
        if(value != null && regex != null && !value.matches(regex)) throw new ValidationException(displayName() + " is invalid.");

        return value;
    }
}
