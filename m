From: Niccolo Rigacci <niccolo@rigacci.org>
Subject: Re: Can't get md array to shut down cleanly
Date: Thu, 6 Jul 2006 17:46:58 +0200
Message-ID: <20060706154658.GC13285@rigacci.org>
References: <bb145bd20607060648p3776d335g55e4bdee4ecaf3c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bb145bd20607060648p3776d335g55e4bdee4ecaf3c4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> My md raid5 still does not always shut down cleanly. The last few
> lines of the shutdown sequence are always as follows:
> 
> [...]
> Will now halt.
> md: stopping all md devices.
> md: md0 still in use.
> Synchronizing SCSI cache for disk /dev/sdd:
> Synchronizing SCSI cache for disk /dev/sdc:
> Synchronizing SCSI cache for disk /dev/sdb:
> Synchronizing SCSI cache for disk /dev/sda:
> Shutdown: hde
> System halted.


May be your shutdown script is doing "halt -h"? Halting the disk 
immediately without letting the RAID to settle to a clean state 
can be the cause?

I see that my Debian avoids the -h option if running RAID,
from /etc/init.d/halt:


        # Don't shut down drives if we're using RAID.
        hddown="-h"
        if grep -qs '^md.*active' /proc/mdstat
        then
                hddown=""
        fi

        # If INIT_HALT=HALT don't poweroff.
        poweroff="-p"
        if [ "$INIT_HALT" = "HALT" ]
        then
                poweroff=""
        fi

        log_action_msg "Will now halt"
        sleep 1
        halt -d -f -i $poweroff $hddown


-- 
Niccolo Rigacci
Firenze - Italy

Iraq, missione di pace: 38839 morti - www.iraqbodycount.net
