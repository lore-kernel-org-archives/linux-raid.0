From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Question regarding the adding of drives to a RAID
Date: Wed, 17 Mar 2004 10:18:26 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16471.35650.360666.861353@notabene.cse.unsw.edu.au>
References: <01e501c40baa$32b20590$350e10ac@pinchy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mark Cuss on Tuesday March 16
To: mcuss@cdlsystems.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 16, mcuss@cdlsystems.com wrote:
> Hello
> 
> I've read through the Software RAID HowTo (a very helpful document) and
> searched through the mailing list, but haven't been able to find the answer
> to my question, so here goes:
> 
> Suppose I have a RAID 1 (striping) RAID set up consisting of two drives,
> creaiedby editing raidtab and issuing an mkraid, etc.  Suppose I've made an
> ext3 filesystem on this device and have files on it.
> 
> Now, suppose this RAID device is full, and I wish to make it bigger.  Is
> there a way for me to add another pair of drives to this array?  I've tried
> doing a "raidhotadd" on my experimental box, that that didn't work.  Later
> reading revealed that raidhotadd is only for adding spares.  I don't think
> simply adding the new drives to the raidtab will help, as those changes will
> only become effective if I mkraid the device, which will torch the data on
> it.
> 
> Is it possible to do this, or am I dreaming?

You are dreaming.

It is possible that something like this might be added one day, but
not in the immediate future.

If you used LVM over raid, you might be able to do something there.

What you could do is:

Assuming first two drives are A and B, and new drives are X and Y.
And that A+B is a raid1 called /dev/md0
and that md1 md2 md3 are not in used.

1/ break the mirror:
	mdadm /dev/md0 -f /dev/B
	mdadm /dev/md0 -r /dev/B

2/ Create md1 and md2 and mirrors of old and new drives
   respectively, but don't include A yet:

	mdadm -C /dev/md1 -l1 -n2 missing /dev/B
	mdadm -C /dev/md2 -l1 -n2 /dev/X /dev/Y

3/ raid0 md1 and m2 together into a raid0

	mdadm -C /dev/md3 -l0 -n2 /dev/md1 /dev/md2

4/ mkfs a filesystem on /dev/md3 and copy you filesystem across

	mkfs -J /dev/md3
	mount /dev/md3 /mnt
	cp -ax /path/to/dev/md0/mountpoint /mnt
	umount /mnt

5/ unmount all and remount new
	unmount /path/to/dev/md0/mountpoint
	mount /dev/md3 /path/to/dev/md0/mountpoint

6/ make sure the data look ok

7/ put A into it's raid1 array
	mdadm /dev/md1 -A /dev/A

8/ make sure the arrays are assembled properly at boot time.

NeilBrown
