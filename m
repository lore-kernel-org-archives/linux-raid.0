From: Neil Brown <neilb@suse.de>
Subject: Re: Problems after reshaping of Raid5 array
Date: Tue, 30 Nov 2010 08:45:01 +1100
Message-ID: <20101130084501.702e7486@notabene.brown>
References: <AANLkTinUU6Mh-cYbyCF_vL2PzGzFKMcqSZmPULxctquh@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinUU6Mh-cYbyCF_vL2PzGzFKMcqSZmPULxctquh@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michele Bonera <mbonera@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 29 Nov 2010 18:24:18 +0100 Michele Bonera <mbonera@gmail.com> wrote:

> Hi all.
> 
> I'm a little bit in panic... and I really need some help to solve this
> (if possible......)...
> 
> I have a storage server in my LAN where I save everything
> for security (sigh).
> 
> The system consists in a 32 GB SSD containing the o.s.
> plus 4 WD EADS 1TB harddisks in RAID5 with all my data.
> The disks are seen by the system as sdb1, sdc1, sdd1, sde1
> 
> Yesterday evening I added another WD, this time an EARS
> (512 byte sectors): I created a partition on it, respecting the
> alignment and then I added it to the array and performed a
> grow command
> 
> mdadm --add /dev/md6 /dev/sdb1 (after adding it, the hd took sdb)
> mdadm --grow /dev/md6 --raid-devices=5
> 
> Reshape started... and worked until today. Or better, until the system
> hangs and I have to sync+remount-ro with the sysrq keys.
> 
> After rebooting, the reshaping restarted, but the disk become sdb
> not sdb1 in the raid array, and the file system became unreadable
> 
> Any ideas of what happened?

Yes.
I think you can fix it by simply failing and removing sdc
Then md/raid5 will recover that data using the parity block, and that should
be correct.

It appears that the partition you created on the new device started at a
multiple of 64K.  When this happen, the superblock at the end of the
partition also looks valid when seen at the end of the whole device.
Somehow mdadm got confused and choose the whole device (sdc) instead of the
partition (sdc1).

I am surprised at this because since mdadm-2.5.1, mdadm will refuse to
assemble an array if it sees two devices that appear to have the same
superblock.  Could you possibly be using something that old??

So when the reshape started, it was writing data for the 5th device to sdc1.
Then after you restared, it was writing data for the 5th device to sdc, which
the same drive of course, but at a different offset.  So everthing that was
written before the crash will look wrong.

So the thing to do is to stop md from reading from sdc at all, as that device
is clearly corrupt.  So just fail and remove it.  Then add it back in again.
If you do re-partition, try to make sure sdc1 does not start at a multiple of
64K (128 sectors).

NeilBrown

