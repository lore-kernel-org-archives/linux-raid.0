From: Phil Turmel <philip@turmel.org>
Subject: Re: multiple disk failures in an md raid6 array
Date: Wed, 03 Apr 2013 19:33:07 -0400
Message-ID: <515CBC33.20402@turmel.org>
References: <CD81A492.400C6%michael.vanhorn@wright.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CD81A492.400C6%michael.vanhorn@wright.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mike,

On 04/03/2013 09:19 AM, Vanhorn, Mike wrote:

> Now, I don't think that 3 disks have all gone bad at the same time, but as
> md seems to think that they have, how do I proceed with this?

They generally don't all go bad together.  I smell a classic error timeout
mismatch between non-raid drives and linux driver defaults.

Aside from that, it should be just an --assemble --force with at least the
five "best" drives (determined by event counts).  But you need to fix your
timeouts first, or the array will keep failing.

But first, before *any* other task, you need to completely document your
devices:

mdadm -E /dev/sd[cdfghij]1 >examine.txt
lsdrv >lsdrv.txt
for x in /dev/sd[cdfghij] ; do smartctl -x $x ; done >smart.txt
for x in /sys/block/sd[cdfghij] ; do echo $x: $(< $x/device/timeout) ; done >timeout.txt

{in lieu of lsdrv[1], you could excerpt "ls -l /dev/disk/by-id/"}

> Normally, it's a RAID 6 array, with sdc - sdi being active and sdj being a
> spare (that it, 8 disks total with one spare).

Ok.

[trim /]

> It seems that at some point last night, sde went bad and was taken out of
> the array and the spare, sdj, was put in it's place and the raid began to
> rebuild. At that point, I would have waited until the rebuild was
> complete, and then replaced sde and brought it all back. However, the
> rebuild seems to have died, and now I have the situation shown above.

Ok.

> So, I can believe that sde actually is bad, but it seems unlikely to me
> that all of them are bad, especially since the smart tests I do have all
> been coming back fine up to this point. Actually, according to smart, most
> of them are good:

[trim /]

> system entirely). And sdj appears to have enough bad block that smart is
> labeling it as bad:
> 
> [root ~]# /usr/sbin/smartctl -H -d ata /dev/sde
> smartctl 5.42 2011-10-20 r3458 [x86_64-linux-2.6.18-308.13.1.el5] (local
> build)
> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net
> 
> Smartctl open device: /dev/sde failed: No such device
> [root ~]# /usr/sbin/smartctl -H -d ata /dev/sdj
> smartctl 5.42 2011-10-20 r3458 [x86_64-linux-2.6.18-308.13.1.el5] (local
> build)
> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: FAILED!
> Drive failure expected in less than 24 hours. SAVE ALL DATA.
> Failed Attributes:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED
> WHEN_FAILED RAW_VALUE
>   5 Reallocated_Sector_Ct   0x0033   058   058   140    Pre-fail  Always
> FAILING_NOW 1134

Yup. Toast.  Discard /dev/sdj along with /dev/sde.

> Is there someway I can keep this array going? I do have one spare disk on
> the shelf that I can put in (which is what I would have done), but how to
> I get it to consider sdc and sdf as okay?

I recommend:

1) Fix timeouts as needed.  Either set your drives' ERC to 7.0 seconds,
or raise the driver timeouts ~180 seconds.  Modern *desktop* drives go to
great lengths to read bad sectors--trying for two minutes or more whenever bad
sectors are encountered.  Modern *enterprise* drives, and other drives
advertised as raid-capable have short error timeouts by default (typically 7.0
seconds).  When a desktop drive is in error recovery, it *ignores* the
controller until it has an answer.  Linux MD raid will see the driver timeout
in 30 seconds, decide to rewrite the problem sector, but the drive isn't
listening, so it gets kicked out.

2) Stop the array and re-assembly with:

mdadm --assemble --force /dev/md0 /dev/sd[cdfghi]

3) Manually scrub the degraded array (effectively raid5).  This will fix your
latent unrecoverable read errors, so long as you don't have too many.

echo check >/sys/block/md0/md/sync_action
cat /proc/mdstat

4) Add new drive(s) and let the array rebuild.  (Make sure the new drives have
proper timeouts, too.)

5) Add appropriate instructions to rc.local to set proper timeouts on every boot.

6) Add cronjobs that will trigger a regular scrub (weekly?) and long smart
self-tests.

HTH,

Phil

[1] http://github.com/pturmel/lsdrv





