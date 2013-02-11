From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: raid/device failure
Date: Sun, 10 Feb 2013 19:55:18 -0700
Message-ID: <201302101955.19121.thomas@fjellstrom.ca>
References: <201302101827.36116.thomas@fjellstrom.ca> <511852EF.9070201@turmel.org>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511852EF.9070201@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On February 10, 2013, Phil Turmel wrote:
> On 02/10/2013 08:27 PM, Thomas Fjellstrom wrote:
> > I've re-configured my NAS box (still haven't put it into "production") to
> > be a raid5 over 7 2TB consumer seagate barracuda drives, and with some
> > tweaking, performance was looking stellar.
> 
> > Unfortunately I started seeing some messages in dmesg that worried me:
> [trim /]
> 
> The MD subsystem keeps a count of read errors on each device, corrected
> or not, and kicks the drive out when the count reaches twenty (20).
> Every hour, the accumulated count is cut in half to allow for general
> URE "maintenenance" in regular scrubs.  This behavior and the count are
> hardcoded in the kernel source.
> 

Interesting. Thats good to know.

> > I've run full S.M.A.R.T. tests (except the conveyance test, probably run
> > that tonight and see what happens) on all drives in the array, and there
> > are no obvious warnings or errors in the S.M.A.R.T. restults at all.
> > Including reallocated (pending or not) sectors.
> 
> MD fixed most of these errors, so I wouldn't expect to see them in SMART
> unless the fix triggered a relocation.  But some weren't corrected--so I
> would be concerned that MD and SMART don't agree.

That is what I was wondering. I tought an uncorrected read error meant it 
wrote the data back out, and then a read of that data again was wrong.

> Have these drives ever been scrubbed?  (I vaguely recall you mentioning
> new drives...)  If they are new and already had a URE, I'd be concerned
> about mishandling during shipping.  If they aren't new, I'd
> destructively exercise them and retest.

They are new in that they haven't been used very much at all yet, and I 
haven't done a full scrub over every sector. I have run some lenghy tests 
using iozone over 32GB or more space (individually, and as part of a raid6), 
but as a bunch of parameters have changed from my last setup (raid5 vs raid6, 
xfs inode32 vs inode64), and xfs/md may or may not have alloated the test 
files from different areas of the device, so I can't be sure that the same 
general area of the disks were being accessed.

I did think that a full destructive write test may be in order, just to make 
sure. I've seen a drive throw errors at me, refuse to reallocate a sector 
untill it was written over manually, and then work fine afterwards.

> > I've seen references while searching for possible causes, where people
> > had this error occur with faulty cables, or SAS backplanes. Is this a
> > likely senario? The cables are brand new, but anything is possible.
> > 
> > The card is a IBM M1015 8 port HBA flashed with the LSI 9211-8i IT
> > firmware, and no BIOS.
> 
> It might not hurt to recheck your power supply rating vs. load.  If you
> can't find anything else, a data-logging voltmeter with min/max capture
> would be my tool of choice.
> 
> http://www.fluke.com/fluke/usen/digital-multimeters/fluke-287.htm?PID=56058

The PSU is overspeced if anything. But that doesn't mean it's not faulty in 
some way. It's a Seasonic G series 450W 80+ gold PSU. The system at full load 
should come in at just over half of that (core i3 2120, intel s1200kp m-itx 
board, hba, 7 hdds, 2 ssds, 2 x 8GB ddr3 1333mhz ECC ram).
 
I have an Agilent U1253B ( http://goo.gl/kl1aC ) which should be adequate to 
test with.

The NAS is on a 1000VA (600W?) UPS, so incomming power should be decently 
clean and even (assuming the UPS isn't bad).

> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
