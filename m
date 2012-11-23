From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: mdadm --fail doesn't mark device as failed?
Date: Fri, 23 Nov 2012 15:58:25 -0800
Message-ID: <1353715105.18439.14.camel@corn.betterworld.us>
References: <1353514677.5795.14.camel@corn.betterworld.us>
	 <20121122154027.39a21f09@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121122154027.39a21f09@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: ross@biostat.ucsf.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2012-11-22 at 15:40 +1100, NeilBrown wrote:
> On Wed, 21 Nov 2012 08:17:57 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrote:
> 
> > After I failed and removed a partition, mdadm --examine seems to show
> > that partition is fine.
> 
> Correct.  When a device fails it is assumed that it has failed and probably
> cannot be written to.  So no attempt is made to write to it, so it will look
> unchanged to --examine.
> 
> All the other devices in the array will record the fact that that device is
> now faulty, and their event counts are increased so their idea of the status
> of the various devices will take priority over the info stored on the faulty
> device - should it still be readable.
> 
> > 
> > Perhaps related to this, I failed a partition and when I rebooted it
> > came up as the sole member of its RAID array.
> 
> This is a bug which is fixed in my mdadm development tree which will
> eventually become mdadm-3.3.
Could you say more about the bug, or point me to details?  The behavior
has me a bit spooked and worried about putting drives in my machine,
given that all my drives have partitions that participated in md0 and
md1 at various times.  If I knew exactly what triggered it I could
proceed more effectively, and less dangerously.

I guess I could break in the initrd code (e.g., break=init option when
the kernel is loaded) and check if things look OK before letting it
pivot to the real system.

Also, do the fixes involve any kernel-level code?

> 
> Does the other decice get assembled into a different array, so you
> end up with two arrays (split brain)?
No, if I understand the question.  md1 was originally sda3 and sdc3.
After failing sdc3 I added sdd4 and sde4, and grew md1 to use both new
drives.  When the system rebooted, md1 consisted of sdc3 only, and the
other paritions were left as partition.  In at least some boot
environments sdd4 and sde4 were not recognized by the kernel, presumably
because they were on GPT  disks.  I know the 2.6.32 kernel under Knoppix
6 did not recognize them; whether the first reboot, using the Debian
initrd and 2.6.32 kernel could see them I'm not sure.

Later I found the debian initrd would not activate the md devices if
they were missing any disks; given that, it's puzzling that it did
activate md1 with sdc3, since sdc3 thought it was in a 2 disk array.

> 
> What can happen is "mdadm --incremental /dev/whatever" is call on each device
> and that results in the correct array (with non-failed device) being
> assembled.
> Then "mdadm -As" gets run and it sees the failed device and doesn't notice
> the other array, so it assembles the failed device into an array of its own.
> 
> The fix causes "mdadm -As" to notice the arrays that "mdadm --incremental"
> has created.
> 
> 
> > 
> > Is this behavior expected?  Is there a way to make the failures more
> > convincing?
> 
> mdadm --zero /dev/whatever
Is zeroing the superblock sufficient?  I'd like to preserve the data.
> 
> after failing and removing the device.
> Or unplug it and put in an acid bath - that makes failure pretty convincing.
> 
> NeilBrown

