From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Can't start raid 5 when device names have changed
Date: Tue, 14 Jan 2003 06:21:27 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15907.4535.265559.726018@notabene.cse.unsw.edu.au>
References: <200301100335.h0A3ZHt02424@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from bugzilla@watkins-home.com on Thursday January 9
To: bugzilla@watkins-home.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 9, bugzilla@watkins-home.com wrote:
> This is reported on http://bugzilla.redhat.com/bugzilla as bug # 81258
> 
> Description of problem:
> I have a raid 5 with 4 disks.  sda1, sda2, sda3, sda4

Hmm... These ar partitions on the same disc.  I assume a typos...

> I have added 2 disks to my system.
> The new disks are sdb and sdd.  At first they did not have a valid partion 
> table.  I got this error on both disks:
> md: could not lock sdb1, zero-size? Marking faulty.
> md: could not import sdb1, trying to run array nevertheless.
>  [events: 00000004]
> md: could not lock sdd1, zero-size? Marking faulty.
> md: could not import sdd1, trying to run array nevertheless.
> 
> That should not be a problem because the raid 5 disks are now sda1, sdc1, sde1 
> and sdf1.
> 
> I did change raidtab before I shutdown to add the new disks.  The system seems 
> to ignore raidtab for existing arrays.  Must only use the file when you use 
> mkraid.
> 
> I have since partitioned the 2 disks sdb and sdd with type fd.
> raidstart still fails.

raidstart is fundamentally broken.
What it does is read raidtab, find the first device name mentioned for
an array, and tell the kernel to load a raid array based on that
device.
The kernel then reads the raid superblock off that device, extracts a
list of device major/minor numbers from that superblock and tries to
build a raid array from these devices.
So obviously if:
  -  The first device listed in raidtab has failed or
  -  any device has changed major/minor number
then the process will fail.

I strongly recommend: never use raidstart.  I recommend distributions
don't even distribute it.
You should either use the raidautodetect partition type, or use mdadm
to assemble raid arrays.  raidstart just isn't a workable option in
general.

NeilBrown
