From: George Rapp <george.rapp@gmail.com>
Subject: Re: RAID 6 "Failed to restore critical section for reshape, sorry." -
 recovery advice?
Date: Tue, 22 Dec 2015 21:04:14 -0500
Message-ID: <CAF-Kpga8toqetF+g6wYbUVHKngkRB8QMTyRy39Jnxn0P6w8ouQ@mail.gmail.com>
References: <CAF-Kpgb57-LoNy=-jy76ZcE=YPABmARzfsHNitJNZyw3v2AShw@mail.gmail.com>
 <alpine.DEB.2.02.1512100918520.20919@uplift.swm.pp.se> <CAF-KpgaLr-qA_RJiDYstFv-=EoHH-Ea3o1q3G3tXC4nX=Wt2XA@mail.gmail.com>
 <CAF-KpgYe9Vxgcy2E5T1_9HdEM0YMfATMzN7WcjHra_EE+sOOTg@mail.gmail.com> <87d1u060sv.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1u060sv.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Dec 20, 2015 at 8:35 PM, NeilBrown <nfbrown@novell.com> wrote:
> On Fri, Dec 11 2015, George Rapp wrote:
>>
>> I appear to be too early in the reshape for auto-recovery, but too far
>> along to just say "never mind on that whole reshape business". Any
>> other thoughts?
>>
>
> What this means is that you've hit a corner case that was never thought
> through properly and isn't handled correctly.

Neil -

Thanks for the reply. Please see my comments inline below.

> The current state of the array is (I think) that it looks like a reshape
> to reduce the number of devices in the array has very nearly completed.
> Only the first stripe needs to be completed.  Whether that first stripe
> is still in the old "N+1" device layout or the new "N" device layout is
> unknown to the kernel - this information is only in the backup file
> (which doesn't exist).

Hmmm. Maybe you're thinking of a different case. This is mine:
http://marc.info/?l=linux-raid&m=143880359028232&w=2

My problem was that I was *increasing* the number of devices from 5 to
6. Also, I don't believe the reshape actually got anywhere, per
/proc/mdstat, which I was watching at the time, because the kernel was
denied write access to my backup file by SELinux.

> By telling mdadm --invalid-backup, you effectively tell mdadm that there
> is nothing useful in the backup file so it should know that the reshape
> has actually completed.  But it has no way to tell the kernel that.
> What it should do in this case is (I think) rewrite the metadata to
> record that the reshape is complete.  But it doesn't.

IMHO, it'd be better in my case to revert to a 5-drive array and
rewrite the metadata to reflect that, since I don't believe the
reshape ever actually began. Once I have access to the array again and
have fsck'ed the filesystem, then I can re-try the "mdadm --grow
--raid-devices=6" command (with SELinux disabled, and watching from
the dunce chair in the opposite corner of the room ... 8^) later.

> I shouldn't be too hard to fix, but it isn't trivial either and I'm
> unlikely to get anywhere before the Christmas break.
>
> If you can get reshape to work at all (disable selinux?) you could try
> --update=revert-reshape and let the reshape to more devices progress for
> a while, and then revert it.
>
> If you cannot get anywhere, then use
>   "mdadm --dump=/tmp/whatever /dev/mdthing"
>
> to create a copy of the metadata in some spares files.
> Then tar those up (a compressed tarchive should be tiny) and email them.
> Then I can try and see if I can make something work on exactly the array
> you have.

Since the array won't run, I can't obtain the metadata you're looking for:

# mdadm --dump=/home/gwr/c/dev-md4-mdadm-dump /dev/md4
mdadm: Cannot find RAID metadata on /dev/md4

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md4 : inactive dm-2[5](S) dm-1[1](S) dm-4[8](S) dm-5[7](S) dm-0[0](S) dm-3[6](S)
      11513452944 blocks super 1.2

(the funny member names are the overlay files I created to experiment
with various recovery operations nondestructively).

I was able to dump the metadata from the six component devices of the
RAID 6 array with:

# mdadm --dump=/home/gwr/c/dev-md4-mdadm-dump /dev/sdj1
/dev/sdj1 saved as /home/gwr/c/dev-md4-mdadm-dump/sdj1.
/dev/sdj1 also saved as
/home/gwr/c/dev-md4-mdadm-dump/wwn-0x5000cca222d7b996-part1.
/dev/sdj1 also saved as
/home/gwr/c/dev-md4-mdadm-dump/wwn-0x13372914453769768960x-part1.
/dev/sdj1 also saved as
/home/gwr/c/dev-md4-mdadm-dump/ata-Hitachi_HUA722020ALA331_B9HP5Y2F-part1.

but after doing that, I have a whole bunch of huge (presumabily
sparse) files in my output directory:

[root@backend3 dev-md4-mdadm-dump]# ll
total 192
-rw-r--r-- 4 root root 1964963324416 Dec 22 20:42
ata-Hitachi_HUA722020ALA331_B8HGR23Z-part1
-rw-r--r-- 4 root root 1964964405248 Dec 22 20:42
ata-Hitachi_HUA722020ALA331_B9HP5Y2F-part1
-rw-r--r-- 4 root root 1964963324416 Dec 22 20:42
ata-ST2000DL003-9VT166_6YD0YXL1-part1
-rw-r--r-- 4 root root 1964963323392 Dec 22 20:42
ata-ST32000542AS_5XW29Z1K-part4
-rw-r--r-- 4 root root 1964964405248 Dec 22 20:41
ata-ST32000542AS_5XW2D8GA-part4
-rw-r--r-- 4 root root 1964968599552 Dec 22 20:42
ata-TP02000GB_TPW140709340083-part4
-rw-r--r-- 4 root root 1964964405248 Dec 22 20:41 sdc4
-rw-r--r-- 4 root root 1964963323392 Dec 22 20:42 sdd4
-rw-r--r-- 4 root root 1964968599552 Dec 22 20:42 sdg4
-rw-r--r-- 4 root root 1964963324416 Dec 22 20:42 sdh1
-rw-r--r-- 4 root root 1964963324416 Dec 22 20:42 sdi1
-rw-r--r-- 4 root root 1964964405248 Dec 22 20:42 sdj1
-rw-r--r-- 4 root root 1964964405248 Dec 22 20:42
wwn-0x13372914453769768960x-part1
-rw-r--r-- 4 root root 1964963324416 Dec 22 20:42
wwn-0x14378343057695330304x-part1
-rw-r--r-- 4 root root 1964964405248 Dec 22 20:41
wwn-0x1508759625694990336x-part4
-rw-r--r-- 4 root root 1964963323392 Dec 22 20:42
wwn-0x4884205575019188224x-part4
-rw-r--r-- 4 root root 1964963323392 Dec 22 20:42 wwn-0x5000c5002f1743c8-part4
-rw-r--r-- 4 root root 1964964405248 Dec 22 20:41 wwn-0x5000c50030e214f0-part4
-rw-r--r-- 4 root root 1964963324416 Dec 22 20:42 wwn-0x5000c5003e0f5862-part1
-rw-r--r-- 4 root root 1964963324416 Dec 22 20:42 wwn-0x5000cca222d4c78a-part1
-rw-r--r-- 4 root root 1964964405248 Dec 22 20:42 wwn-0x5000cca222d7b996-part1
-rw-r--r-- 4 root root 1964968599552 Dec 22 20:42 wwn-0x50014ee208b56ae8-part4
-rw-r--r-- 4 root root 1964963324416 Dec 22 20:42
wwn-0x6368721060505866240x-part1
-rw-r--r-- 4 root root 1964968599552 Dec 22 20:42
wwn-0x7703416737422790657x-part4

and "tar -c -v -z -f dev-md4-mdadm-dump.tar.gz dev-md4-mdadm-dump/"
didn't produce a tiny file, but a huge one (15MB and growing in just
10 minutes), so I killed it.

Any further thoughts about how to proceed? Thanks for your help.

George
-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
