From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm degraded RAID5 failure
Date: Sat, 25 Oct 2008 17:30:12 +1100
Message-ID: <18690.48372.369694.309381@notabene.brown>
References: <6cc8e9ed0810221350o2b8b3aedm3d1c229fe7e66163@mail.gmail.com>
	<6cc8e9ed0810221352y7427cb7dmfc7c3fcefd495bb9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Steve Evans on Wednesday October 22
Sender: linux-raid-owner@vger.kernel.org
To: Steve Evans <jeeping@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday October 22, jeeping@gmail.com wrote:
> Hi all..

Hi.
You need to get a mail client that doesn't destroy the formatting of
the text that you paste in.  But while it is an inconvenience, we
should be able to persevere...

> 
> I had one of the disks in my 3 disk RAID5 die on me this week. When
> attempting to replace the disk via a hot swap (USB), the RAID didn't
> like it. It decided to mark one of my remaining 2 disks as faulty.

It would be interesting to see the kernel logs at this time.  Maybe
the USB bus glitched while you were plugging the device in.


> 
> Can someone *please* help me get the raid back!?

Probably.

> 
> More details -
> 
> Drives are /dev/sdb1, /dev/sdc1 & /dev/sdd1

... or were.  USB device names can change every time you plug them in.

> 
> sdc1 was the one that died earlier this week
> sdb1 appears to be the one that was marked as faulty
> 
> mdadm detail before sdc1 was plugged in -
> 
> root@imp[~]:11 # mdadm --detail /dev/md1
> /dev/md1:
...
> 
> Number Major Minor RaidDevice State
> 0 8 17 0 active sync /dev/sdb1
> 1 0 0 - removed
> 2 8 49 2 active sync /dev/sdd1

So the array thinks the 2nd of 3 is missing.  That is consistent with
your description.

> 
> 
> then after plugging in the replacement sdc1 -
> 
> root@imp[~]:13 # mdadm --add /dev/md1 /dev/sdc1
> mdadm: hot added /dev/sdc1
> root@imp[~]:14 #
> root@imp[~]:14 #
> root@imp[~]:14 # mdadm --detail /dev/md1
> /dev/md1:
...
> 
> Number Major Minor RaidDevice State
> 0 0 0 - removed
> 1 0 0 - removed
> 2 8 49 2 active sync /dev/sdd1
> 
> 3 8 33 0 spare rebuilding /dev/sdc1
> 4 8 17 - faulty /dev/sdb1

Yes, sdb must have got an error and failed while sdc was rebuilding.
Sad.  That suggests that it didn't fail at the moment of USB
insertion, but a little later.  Not conclusively though.

> 
> Shortly after this, subsequent mdadm --details stopped responding.. So
> I rebooted in the hope I could reset and problems with the hot add..
> 
> Now, I'm unable to assemble the raid with the 2 working drives -
> 
> mdadm --assemble /dev/md1 /dev/sdb1 /dev/sdd1
> 
> doesn't work -
> 
> mdadm: /dev/md1 assembled from 1 drive and 1 spare - not enough to
> start the array.

You have rebooted so device names may have changed.
If it thought you had named a good drive and a spare, it probably saw
the device that was originally sdb (and possibly still is)
and the device that was originally sdc (and now might be sdd).

> 
> mdadm --assemble --force /dev/md1 /dev/sdb1 /dev/sdd1
> 
> doesn't' work either

What error messages?  Always best to be explicit.
Adding "-v" to the --assemble line would help too.

> 
> This -
> 
> mdadm --assemble --force --run /dev/md1 /dev/sdb1 /dev/sdd1
> 
> Did work partially -
> 
Hmm.. That really shouldn't have worked.  The kernel should have
rejected the array...

> 
> Here's the output from mdadm -E on each of the 2 drives -

Uhm... There should be 3 drives?
The 'good' one, the 'new' one, and the one that seemed to fail
immediately after you plugged in the 'new' one.

> 
> /dev/sdb1:
..
> Number Major Minor RaidDevice State
> this 3 8 33 3 spare /dev/sdc1
> 
> 0 0 0 0 0 removed
> 1 1 0 0 1 faulty removed
> 2 2 8 49 2 active sync /dev/sdd1
> 3 3 8 33 3 spare /dev/sdc1

sdb looks like the new one.

> /dev/sdd1:
...
> 
> Number Major Minor RaidDevice State
> this 2 8 49 2 active sync /dev/sdd1
> 
> 0 0 0 0 0 removed
> 1 1 0 0 1 faulty removed
> 2 2 8 49 2 active sync /dev/sdd1
> 3 3 8 33 0 spare /dev/sdc1

sdd looks like the good one.

Where is the "one that seemed to fail" which was once called sdb ??
> 
> Is all the data lost, or can I recover from this?

Try

  mdadm --examine --brief --verbose /dev/sd*

That will list anything that looks like an array.
e.g. (on my devel machine)

# mdadm --examine --brief --verbose /dev/sd*
ARRAY /dev/md0 level=raid5 num-devices=3 UUID=cfd6a841:c24600be:c4297cb4:f8ef633e
   devices=/dev/sdb,/dev/sdc,/dev/sdd
ARRAY /dev/md0 level=raid5 num-devices=2 UUID=cb711aad:db89ffc8:faa4816a:59e602da
   devices=/dev/sda11,/dev/sda12

Take careful note of the "devices=" part.  That lists sets of devices
(maybe only one set in your case) which are all part of an array.
So I have two array, one across /dev/sdb, /dev/sdc, /dev/sdd and
one across /dev/sda11 and /dev/sda12.

Then

  mdadm --assemble --force --verbose /dev/md1 /dev/sd....

where you list all the devices in the device= section for the array
you want to try to start.

Report the output of that command and whether it was successful.

NeilBrown
