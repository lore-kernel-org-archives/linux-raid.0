From: Derek Vadala <derek@cynicism.com>
Subject: Re: mdadm and --program
Date: Thu, 3 Oct 2002 16:59:48 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021003205948.EC0F43B828@jaded.cynicism.com>
References: <200210031601.35139.jbyrkit@pcpao.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200210031601.35139.jbyrkit@pcpao.org>
To: Jeff Byrkit <jbyrkit@pcpao.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 3 Oct 2002, Jeff Byrkit wrote:

> # mdadm --follow --program /etc/handle-mdadm-events  --delay 1 /dev/md0
>
> where handle-mdadm-events is (culled from previous posts):
>
> echo $*
> logger -p kern.crit -t RAID $*

Does your script have a #! line at the top, for example:

#!/bin/bash

You could alternatively use:

# mdadm --follow --program='/bin/bash /etc/handle-mdadm-events' --delay=1 /dev/md0

> but I never get anything at my terminal or in the log. If I don't use the
> --program, it gives me:

Don't forget to make sure /etc/syslog.conf has an appropriate entry too.

> anyone have any ideas? can I do --program "echo $*" ? just to get it to do
> something?

Yeah, but you don't need $* and you should use the full path to echo.

# mdadm -F /dev/md0 -p/bin/echo -d1

---
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

