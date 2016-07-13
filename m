From: Phil Turmel <philip@turmel.org>
Subject: Re: Help with assembling a stopped array
Date: Wed, 13 Jul 2016 11:29:21 -0400
Message-ID: <caf338d7-cc3f-0aca-e928-7619a64d888c@turmel.org>
References: <CANz1=TGr3_ayX-CxcjsBx6Q0Ggh5PXp1STmqHW1XuMS8GGE7Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANz1=TGr3_ayX-CxcjsBx6Q0Ggh5PXp1STmqHW1XuMS8GGE7Lg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vegard Haugland <vegard@haugland.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Vegard,

On 07/12/2016 09:23 PM, Vegard Haugland wrote:
> Hi all,
> 
> I have a raid6 setup (called /dev/md4) with 10 harddrives, ranged from
> sda to sdj.

You'll have to supply more detail.  Uncut mdadm -E /dev/sdXY for each
member device in its current state.  smartctl -iA -l scterc /dev/sdX for
each member device's drive.

> One of my drives fell out recently, /dev/sde3/ (not entirely sure how
> this happened), but I readded it as /dev/sdk3, and the array started
> rebuilding. This went on for several hours, and it hit 60% completed
> around 8 hours ago.
> 
> However, a few hours after that, I lost both /dev/sdg3 and /dev/sdh3 -
> and the array stopped completely. My OS was also running on that
> array, so my entire system freezed forcing me to reboot.

You would not believe how often we encounter reports like yours where
more member devices fail while trying to rebuild/resync/re-add after a
first failure.  There's some reading assignments for you at the at end
of this mail that you *must* read and understand or this array will blow
up again.

> I've now booted into busybox and md tells me that it cannot reassemble
> the array as it can only find 7 out of 10 good drives..
> 
> I then read the instructions on
> https://raid.wiki.kernel.org/index.php/RAID_Recovery, I started using
> mdadm --examine and found that 8 out of 10 drives has identical event
> counters. The two that deviates from this is /dev/sdg3 and /dev/sdh3.
> I'm not entirely sure if the disk symbolic names are still the same,
> so I further assume that the 8/10 drives that are still good are the
> ones that were running OK before any of this started happening.
> 
> As such, I try forcing a reassemble using mdadm -A /dev/md4 --force.
> When I now run mdadm -D /md4, it lists one device as spare (even
> though my array does not use any spares) - and I guess this is the
> main reason the array doesn't start. Can anyone confirm this, or am i
> missing something?

When you used --assemble --force, did you spell out exactly which
devices to use?

> Also, if I try setting the spare as failed by running mdadm -f
> /dev/md4 /dev/sde3, I get "no such device" (as recalled from human
> memory). Removing it works (mdadm -r /dev/md4 /dev/sde3), but every
> time I reassemble, it gets the "spare" tag. I also tried reassemble
> with force, but the same happened..
> 
> The initrd on this computer does not have networking unfortunately, so
> I cannot attach any output from any logs.

Boot from a modern rescueCD or USB drive that lets you save the
requested information and output on the console.  Include any dmesg
content that involves these devices.  When running mdadm, include the -v
option so your console has more info for us.

> If you agree with my summary so far, what should be my next action? Is
> there anything left to try before running mdadm create (with level 6
> and 2 missing drives)?

Absolutely do not use --create!

mdadm --assemble --force is the correct tool, but you *must* resolve the
underlying reason your devices are failing.

Phil

Readings for timeout mismatch issues:  (whole threads if possible)

http://marc.info/?l=linux-raid&m=139050322510249&w=2
http://marc.info/?l=linux-raid&m=135863964624202&w=2
http://marc.info/?l=linux-raid&m=135811522817345&w=1
http://marc.info/?l=linux-raid&m=133761065622164&w=2
http://marc.info/?l=linux-raid&m=132477199207506
http://marc.info/?l=linux-raid&m=133665797115876&w=2
http://marc.info/?l=linux-raid&m=142487508806844&w=3
http://marc.info/?l=linux-raid&m=144535576302583&w=2

