From: "Chris Evans" <chris1@psyctc.org>
Subject: Re: md: can not impport hdb1, has active inodes!
Date: Wed, 03 Mar 2004 09:11:48 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4045A154.12266.4B21C5B@localhost>
References: <16453.13250.331087.281490@notabene.cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <16453.13250.331087.281490@notabene.cse.unsw.edu.au>
References: message from Chris Evans on Wednesday March 3
To: debian-user@lists.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm splitting my response to this post into two.  I'm sure that 
someone out there who knows about mount and /proc/mounts can clarify 
this bit:

On 3 Mar 2004 at 12:24, Neil Brown wrote:

> On Wednesday March 3, chris1@psyctc.org wrote:
> > Aha, didn't know that wrinkle: lovely.  Mount says:
> > /dev/md0 on / type ext3 (rw,errors=remount-ro)
> > proc on /proc type proc (rw)
> > devpts on /dev/pts type devpts (rw,gid=5,mode=620)
> > 
> > and cat /proc/mounts says:
> > rootfs / rootfs rw 0 0
> > /dev/root / ext2 rw 0 0
> > proc /proc proc rw 0 0
> > devpts /dev/pts devpts rw 0 0
> > 
> > Does that "/dev/root" bit indicate anything useful?
> 
> No, but the fact that root is actually 'ext2' even though mount (and
> presumably fstab) thinks it is ext3 is a bit suspicious. 
I suppose that might be because the difference between ext2 and ext3, 
as I understand it, is just a journalling block reserved at the end 
of the normal ext2 space so perhaps /proc/mounts indicates all ext3 
as ext2?

From a quick bit of googling, I understand that /dev/root is a label 
for the root mount point that's passed to the kernel as it loads, in 
my case, I assume that's passed to the kernel from whatever lilo has 
done to the mbr and that this ensures that the kernel then holds that 
mount open (presumably in case it needs to write something back there 
when it quits ... or perhaps it always writes something back there in 
a clean dismount ... I don't know).

Can someone:
a) confirm or deny my hunch that the ext2/ext3 issue is normal?
b) clarify the way that lilo and the kernel interact?

I wonder if it's pertinent that /proc/partitions shows this:

cat /proc/partitions
major minor  #blocks  name
   9     0   78124928 md0
  22     0   80043264 hdc
  22     1   78125008 hdc1
   3    64   80043264 hdb
   3    65   80035798 hdb1

cfdisk /dev/hdb shows a single primary bootable partition occupying 
the entire drive of Linux raid autodetect type.  For /dev/hdc I have 
a single primary bootable partition of the same type and some free 
space (to ensure that there'd be enough room on /dev/hdb1 to add it 
to the array).

Thanks,

Chris
PSYCTC: Psychotherapy, Psychology, Psychiatry, Counselling
   and Therapeutic Communities; practice, research, 
   teaching and consultancy.
Chris Evans & Jo-anne Carlyle
http://psyctc.org/ Email: chris@psyctc.org

