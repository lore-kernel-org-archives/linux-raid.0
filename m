From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID-5 recovery
Date: Mon, 4 Sep 2006 10:11:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0609040958340.21489@uplift.swm.pp.se>
References: <200609031148.56910.clive@vacuumtube.org.uk>
 <Pine.LNX.4.64.0609031530010.12203@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0609031530010.12203@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 3 Sep 2006, dean gaudet wrote:

> that's not quite the current behaviour.  since 2.6.14 or .15 or so md 
> will reconstruct bad blocks from other disks and try writing them. 
> it's only when this fails repeatedly that it knocks the disk out of the 
> array.

Hi. When in 2.6.15 I used the /sys/block/md*/md/sync_action "check" option 
it looked more like it was rebuilding the device than checking it.

Is this behaviour changed in more recent kernels, or did I just 
misunderstand the log output from the check:

# echo "check" > sync_action
# dmesg
md: syncing RAID array md3
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 200000 
KB/sec) for reconstruction.
md: using 128k window, over a total of 248896 blocks.
md: md3: sync done.

This doesn't look like a check, more like a rebuild? Looking at iostat -x 
does indicate that it's reading from one drive and writing to another?

# uname -a
Linux 2.6.15-1-686-smp #2 SMP Mon Mar 6 15:34:50 UTC 2006 i686 GNU/Linux

This is a standard debian kernel.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

-- 
VGER BF report: H 0.329215
