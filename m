From: "Rob Bray" <raid@bymeinc.com>
Subject: Re: RAID-5 recovery
Date: Thu, 7 Sep 2006 21:45:51 -0400 (EDT)
Message-ID: <36355.192.168.0.1.1157679951.squirrel@bymeinc.com>
References: <200609031148.56910.clive@vacuumtube.org.uk>
    <Pine.LNX.4.64.0609031530010.12203@twinlark.arctic.org>
    <Pine.LNX.4.62.0609040958340.21489@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0609040958340.21489@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Hi. When in 2.6.15 I used the /sys/block/md*/md/sync_action "check" option
> it looked more like it was rebuilding the device than checking it.
>
> Is this behaviour changed in more recent kernels, or did I just
> misunderstand the log output from the check:
>
> # echo "check" > sync_action
> # dmesg
> md: syncing RAID array md3
> md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
> md: using maximum available idle IO bandwidth (but not more than 200000
> KB/sec) for reconstruction.
> md: using 128k window, over a total of 248896 blocks.
> md: md3: sync done.
>
> This doesn't look like a check, more like a rebuild? Looking at iostat -x
> does indicate that it's reading from one drive and writing to another?
>
> # uname -a
> Linux 2.6.15-1-686-smp #2 SMP Mon Mar 6 15:34:50 UTC 2006 i686 GNU/Linux
>
> This is a standard debian kernel.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
>
> --
> VGER BF report: H 0.329215
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I didn't see a response to this post -- forgive me if this is a
duplicate.. The following went into 2.6.16 to fix what you mentioned,
although the message will still report "reconstruction" without Neil's
most recent patch to fix the wording:

Author: NeilBrown <neilb@suse.de>
Date:   Fri Jan 6 00:20:26 2006 -0800

    [PATCH] md: allow raid1 to check consistency

    Where performing a user-requested 'check' or 'repair', we read all
readable devices, and compare the contents.  We only write to blocks
which had read errors, or blocks with content that differs from the
first good device found.

