From: Jeff Byrkit <jbyrkit@pcpao.org>
Subject: Re: mdadm and --program
Date: Fri, 4 Oct 2002 07:45:53 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210040745.53281.jbyrkit@pcpao.org>
References: <20021003205948.EC0F43B828@jaded.cynicism.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021003205948.EC0F43B828@jaded.cynicism.com>
To: Derek Vadala <derek@cynicism.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Excellent. I'm new to scripting...guess it's time for this old vms hack to 
learn shell programming....
Thanks again.

On Thursday, October 03 2002 04:59 pm, Derek Vadala wrote:
> On Thu, 3 Oct 2002, Jeff Byrkit wrote:
> > # mdadm --follow --program /etc/handle-mdadm-events  --delay 1 /dev/md0
> >
> > where handle-mdadm-events is (culled from previous posts):
> >
> > echo $*
> > logger -p kern.crit -t RAID $*
>
> Does your script have a #! line at the top, for example:
>
> #!/bin/bash
>
> You could alternatively use:
>
> # mdadm --follow --program='/bin/bash /etc/handle-mdadm-events' --delay=1
> /dev/md0
>
> > but I never get anything at my terminal or in the log. If I don't use the
> > --program, it gives me:
>
> Don't forget to make sure /etc/syslog.conf has an appropriate entry too.
>
> > anyone have any ideas? can I do --program "echo $*" ? just to get it to
> > do something?
>
> Yeah, but you don't need $* and you should use the full path to echo.
>
> # mdadm -F /dev/md0 -p/bin/echo -d1
>
> ---
> Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jeff Byrkit
Assistant Deputy for Information Systems
Pinellas County Property Appraiser

