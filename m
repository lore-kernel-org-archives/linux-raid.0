From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: no good deed goes unpunished...
Date: Fri, 27 Mar 2015 13:42:08 -0500
Message-ID: <CAAMCDef5ejTu4aoYxMRxaRPvV9kKO4qwzbo9jAuPnFDYDoHo0A@mail.gmail.com>
References: <20150327103301.16746hhb6t1sroel@webmail.uniserve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150327103301.16746hhb6t1sroel@webmail.uniserve.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Stevens <geek@uniserve.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I don't know what to make of it.

Everyone will ask you for this info:
mdadm --examine /dev/sdc2              and the same output against /dev/sdb2

On Fri, Mar 27, 2015 at 12:33 PM, Dave Stevens <geek@uniserve.com> wrote:
> From:   Roger Heflin <rogerheflin@gmail.com>
> To:     Dave Stevens <geek@uniserve.com>
> Cc:     Linux RAID <linux-raid@vger.kernel.org>
> Subject: Re: no good deed goes unpunished...
> Date:   Thu, 26 Mar 2015 19:04:45 -0500
> Sender: linux-raid-owner@vger.kernel.org
>
> you should probably do cat /proc/mdstat
>
> It is likely that the livecd may have already tried to assemble it,
> and that the busy is because it is already in use.
>
> If it is already assembled and you want to redo it first you will need
> to stop the assembled array to be able to redo it.
>
> so this is what I did while running the live distro:
>
> # cat /proc/mdstat
>
> Personalities :
>
> md12 : inactive   sda2[0](S)
>         732467520 blocks
>
> md10 : inactive sdc2[2](S) sdb2[1](S)
>         1464935040 blocks
>
> unused devices: <none>
>
>
> It seemed to me that matters were needlessly complicated by possible
> residual issues from my earlier unsuccessful attempts so I rebooted.
>
>
> ------------------------------ reboot ----------------------
>
> # mdadm -A /dev/md13 /dev/sdb2 /dev/sdc2
>
> mdadm : /dev/md13 assembles from 1 drive - not enough to start the array
>
> # cat /proc/mdstat
>
> Personalities :
>
> md13 : inactive sdc2[2](S) sdb2[1](S)
>
>         1464935040 blocks
>
> unused devices : <none>
>
> # mkdir aa
>
> # mount /dev/md13 aa
>
> mount: /dev/md13: can't read superblock
>
> So I still don't see what to do. Advice welcome.
>
> Dave
>
>
>
> --
> "As long as politics is the shadow cast on society by big business,
> the attenuation of the shadow will not change the substance."
>
> -- John Dewey
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
