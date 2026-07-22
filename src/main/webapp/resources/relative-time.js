const relativeTime = new Intl.RelativeTimeFormat(undefined, {numeric: "auto"});
const relativeTimeUnits = [
    ["second", 60],
    ["minute", 60],
    ["hour", 24],
    ["day", 7],
    ["week", 4.345],
    ["month", 12],
    ["year", Number.POSITIVE_INFINITY]
];

function updateRelativeTimes()
{
    document.querySelectorAll("time[data-relative-time]").forEach((element) => {
        const date = new Date(element.dateTime);

        if(Number.isNaN(date.getTime()))
        {
            return;
        }

        let difference = (date.getTime() - Date.now()) / 1000;
        let unit = "second";

        for(const [candidate, limit] of relativeTimeUnits)
        {
            unit = candidate;

            if(Math.abs(difference) < limit)
            {
                break;
            }

            difference /= limit;
        }

        element.textContent = relativeTime.format(Math.round(difference), unit);
        element.title = date.toLocaleString(undefined, {dateStyle: "long", timeStyle: "long"});
    });
}

updateRelativeTimes();
window.setInterval(updateRelativeTimes, 60000);
