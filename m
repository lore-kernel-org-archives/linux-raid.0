From: NeilBrown <neilb@suse.de>
Subject: Re: Growing a single disk into a 2 disk raid0
Date: Sat, 29 Jan 2011 20:10:13 +1100
Message-ID: <20110129201013.390dff00@notabene.brown>
References: <4D42FA3E.6000206@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D42FA3E.6000206@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 28 Jan 2011 12:17:50 -0500 Phillip Susi <psusi@cfl.rr.com> wrote:

> I had someone wanting to take an existing disk full of data and expand
> it by adding a second disk.  This seemed reasonable, and I thought of
> several ways you could do this, but none of them pan out:
> 
> 1)  Create a single disk raid0 using the existing disk, then reshape it
> adding the second disk.  mdadm fails to add the second disk as a spare
> so that you can reshape, with the kernel complaining that personality
> does not support diskops.
> 
> 2)  Create a single disk raid1 using the existing disk, then reshape it
> adding the second disk.  Apparently you can not reshape from raid1 to raid0.
> 
> 3)  Create a raid10 using the existing disk, setting the number of near
> copies to only 1 so as to preserve the existing data, then reshape
> adding the second disk.  I ran into two problems here:
> 
> a) mdadm refuses to create a single disk raid10, saying that at least
> two devices are needed for raid level 4 or 5.  I am surprised that you
> can not create a single disk raid10 even with --force, and the message
> mentions the wrong level.  I would think that a single disk raid10 with
> 2 far copies would be fairly useful.
> 
> b) I tried 2 disks with one missing and mdadm refuses to create a raid10
> with only a single near copy.  The kernel complains that layout 0x101 is
> unsupported.
> 
> Is there any way to accomplish this?

Yes.  Maybe.

You need to use the RAID5 personality to do the re-striping.

You should absolutely test out any procedure you end up with to make sure it
actually works.  e.g. with a couple of USB drives or something like that.
Maybe just a couple of loop-back devices on mostest sized files (100Meg would
be plenty for testing).

Firstly you need to convert the single device into a 2-device RAID4.
Something like:
 
  mdadm -C /dev/md0 -l4 -n2 -e 1.0 /dev/sda missing

The '-e 1.0'. will make sure the metadata goes at the end
of the device.
Note that this will DESTROY the last 8K or so of the device.  And will round
the remaining size down to the chuck size (which might be 512K by default).
You should check that the filesystem doesn't extend that far.  If it does,
you might need to resize the filesystem to be smaller.

Alternately you could create this md0 on the new device, and then
copy the original device onto the new md0 (mkfs, then "cp -a" or similar).

Once you have a degraded 2-drive RAID4 (i.e. with only one drive)  that
contains your data you are ready for step 2.
mdadm-3.2 might do this for you, but it isn't released yet and I haven't
tested so it probably doesn't.
You need to add the second device and then reshape to be a 3-drive RAID4
without the second device being recovered first.
So:

  echo frozen > /sys/block/md0/md/sync_action
  mdadm /dev/md0 --add /dev/the-other-device
  mdadm --grow --force /dev/md0 --raid-disks=2

You will of course test this before trying it on live data.
And you need a fairly recent kernel.

If/when the above works you will have a degraded 3-drive RAID4
which is much like a 2-drive RAID0 except that it does lots of pointless
parity calculations.
You can convert it to RAID0 with the command:

  echo raid0 > /sys/block/md0/md/level

and (drum roll) you have your RAID0 all configured.

You may decide that this isn't worth the effort and that you want to
wait for mdadm to support it natively.  The choice is yours.
But you will need to wait for at least 3.2.1.

If you do experiment with this, please report any success or failure.


NeilBrown
