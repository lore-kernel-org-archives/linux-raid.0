From: Phil Turmel <philip@turmel.org>
Subject: Re: [Recovery] RAID10 hdd failureS help requested
Date: Tue, 24 Sep 2013 15:05:57 -0400
Message-ID: <5241E295.6040105@turmel.org>
References: <CAB4fJqfd1zrw_AS89ufysfyCoKNf6VYj81xov0=7y0aXoYtjxw@mail.gmail.com> <5241A06F.10704@turmel.org> <CAB4fJqezb0sWcUUgRPd4BXoWr3hNBp725gv8xnMOPmcqU8RiRw@mail.gmail.com> <5241B4B7.1010305@turmel.org> <CAB4fJqerQy7PJzK4+WSNAh7YCcHmwoAqB5vMrXeSYqzWawAS+A@mail.gmail.com> <5241C763.6040306@turmel.org> <CAB4fJqeoK-o+xvAc0vnp=ika6=vTV0d6wrJhjwg43c0f7O+K_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB4fJqeoK-o+xvAc0vnp=ika6=vTV0d6wrJhjwg43c0f7O+K_g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Karel Walters <karel.walters@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/24/2013 02:18 PM, Karel Walters wrote:
>  Hi Phil,
> 
> Thank you for all the great help so far!
> 
>> Yes, that dmesg did the trick.  The drive that failed first was #3, and
>> the drive the failed second was #4.  You should create a list of which
>> drive serial number corresponds to which raid device role, with a third
>> column showing the current device name.
> 
> Serial no:              old name  ID     current name
> WD-WCC1T1255024                     /dev/sdc1  new drive
> W1F09XLV            /dev/sdb1 [3]    /dev/sdd1  failed drive 1
> W1F0AXTQ           /dev/sdc1 [4]    /dev/sde1  failed drive 2
> W1F0B6X6            /dev/sdd1 [0]    /dev/sdf1
> S1F04BZT             /dev/sde1 [5]    /dev/sdg1
> W1F0B9ER           /dev/sdf1 [2]    /dev/sdh1
> WD-WMC1T2341606    /dev/sdg1 [1]    /dev/sdi1
> S1F04CWH           /dev/sdh1 [6]    /dev/sdj1  (partially rebuild spare)

Ok, so your create operation will be:

mdadm --create /dev/md1 --level=10 -n 6 --layout=f2 --chunk=64
--data-offset=variable /dev/sdd1:2048 /dev/sdg1:4096 /dev/sdf1:2048
/dev/sdb1:2048 /dev/sdc1:2048 /dev/sde1:2048

I'm actually guessing that /dev/sdb1 and /dev/sdc1 need offset 2048 like
the original devices, not the 4096 of a device added later (newer
mdadm).  With the mixed offsets, you need mdadm version 3.3.

Use "fsck -n" to verify the array before mounting anything, just in case
one or both of those drives really does need :4096.

>> Then, to deal with the large number of pending events, you'll need to do
>> a "check" scrub with a very low speed limit.  To keep you from exceeding
>> the 10/hour read error limit in the MD kernel driver.
> 
> echo 1000 > /proc/sys/dev/raid/speed_limit_min
> echo 10000 > /proc/sys/dev/raid/speed_limit_max
> echo check > /sys/block/md0/md/sync_action
> 
> Would this be ok in such a case?

Looks ok.  You may want to experiment in progress.

Phil
