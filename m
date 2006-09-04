From: Neil Brown <neilb@suse.de>
Subject: Re: checkarray: E: no kernel support for parity checks.
Date: Tue, 5 Sep 2006 07:55:17 +1000
Message-ID: <17660.41157.387561.113867@cse.unsw.edu.au>
References: <2760ec154727cb74d5c8824eb24916a8@logidac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guillaume Filion on Monday September 4
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Filion <gfk@logidac.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday September 4, gfk@logidac.com wrote:
> Hi,
> 
> I'm not sure if this is the right place to ask this question, but a 
> Google search didn't turned out anything relevant, so I'm taking a 
> chance here.
> 
> I have my root on software raid on Debian and every night, cron is 
> sending me this error:
> -----
> Subject: Cron <root@ali> [ -x /usr/share/mdadm/checkarray ] && 
> /usr/share/mdadm/checkarray --cron --all --quiet
> 
> checkarray: E: no kernel support for parity checks.
> -----
> 
> Looking at the code, it looks like this is where the error is reported:
> if [ -z "$(ls /sys/block/md*/md/sync_action 2>/dev/null)" ]; then
>    [ $quiet -lt 2 ] && echo "$PROGNAME: E: no kernel support for parity 
> checks." >&2
>    exit 3
> fi
> 
> My /sys directory is empty:
> gfk@ali:~$ ls -ld /sys
> drwxr-xr-x 2 root root 4096 Nov 12  2005 /sys
> gfk@ali:~$ ls -l /sys
> total 0
> 
> Is it normal that /sys is empty? I can't find how to populate it, if 
> someone could give me a clue... :-)

mount -t sysfs sysfs /sys

NeilBrown
