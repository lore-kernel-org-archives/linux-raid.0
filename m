From: George Rapp <george.rapp@gmail.com>
Subject: Re: RAID 6 "Failed to restore critical section for reshape, sorry." -
 recovery advice?
Date: Fri, 22 Jan 2016 14:24:59 -0500
Message-ID: <CAF-Kpgb8W0Buy=XM0KUai_Y35xDmnTZz5Ar43UuzRpv4CSEYCQ@mail.gmail.com>
References: <CAF-Kpgb57-LoNy=-jy76ZcE=YPABmARzfsHNitJNZyw3v2AShw@mail.gmail.com>
 <alpine.DEB.2.02.1512100918520.20919@uplift.swm.pp.se> <CAF-KpgaLr-qA_RJiDYstFv-=EoHH-Ea3o1q3G3tXC4nX=Wt2XA@mail.gmail.com>
 <CAF-KpgYe9Vxgcy2E5T1_9HdEM0YMfATMzN7WcjHra_EE+sOOTg@mail.gmail.com>
 <87d1u060sv.fsf@notabene.neil.brown.name> <CAF-Kpga8toqetF+g6wYbUVHKngkRB8QMTyRy39Jnxn0P6w8ouQ@mail.gmail.com>
 <871tad3o2q.fsf@notabene.neil.brown.name> <CAF-KpgZ=HY_HKvj5buFOKseUV0GLeOLR1m3B0EYxrYcD3R5ieA@mail.gmail.com>
 <87r3hyxf69.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r3hyxf69.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jan 3, 2016 at 9:16 PM, NeilBrown <neilb@suse.com> wrote:
> On Sun, Dec 27 2015, George Rapp wrote:
>
> If you apply the following patch to mdadm (
>    git clone git://neil.brown.name/mdadm
>    apply patch
>    make
> ) and then try to assemble with --update=revert-reshape, it should
> assemble as a 5-device array with no reshape happening.
>
> I probably want more safety checks before this goes upstream, but it
> is safe enough for you.
>
> [patch snipped]
>

I've replied privately to Neil, but for list archive purposes, his
patch solved my problem.

After applying his patch, I used the custom-build version of mdadm to
assemble my array:

# UUID=$(mdadm -E /dev/sdd4 | perl -ne '/Array UUID : (\S+)/ and print $1')
# DEVICES=$(cat /proc/partitions | parallel --tagstring {5} --colsep '
+' mdadm -E /dev/{5} |grep $UUID | parallel --colsep '\t' echo
/dev/{1})
# ./mdadm --assemble --verbose --update=revert-reshape /dev/md4 $DEVICES
mdadm: looking for devices for /dev/md4
mdadm: /dev/sdd4 is identified as a member of /dev/md4, slot 0.
mdadm: /dev/sdc4 is identified as a member of /dev/md4, slot 1.
mdadm: /dev/sdg4 is identified as a member of /dev/md4, slot 2.
mdadm: /dev/sdh1 is identified as a member of /dev/md4, slot 3.
mdadm: /dev/sdi1 is identified as a member of /dev/md4, slot 5.
mdadm: /dev/sdj1 is identified as a member of /dev/md4, slot 4.
mdadm: device 10 in /dev/md4 has wrong state in superblock, but
/dev/sdi1 seems ok
mdadm: added /dev/sdc4 to /dev/md4 as 1
mdadm: added /dev/sdg4 to /dev/md4 as 2
mdadm: added /dev/sdh1 to /dev/md4 as 3
mdadm: added /dev/sdj1 to /dev/md4 as 4
mdadm: added /dev/sdi1 to /dev/md4 as 5
mdadm: added /dev/sdd4 to /dev/md4 as 0
mdadm: /dev/md4 has been started with 5 drives and 1 spare.
# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md4 : active raid6 sdd4[0] sdi1[8](S) sdj1[7] sdh1[6] sdg4[5] sdc4[1]
      5756723712 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]
      bitmap: 0/15 pages [0KB], 65536KB chunk

For future reference, I would highly recommend executing

# setenforce 0

or, if you're really paranoid, disabling SELinux completely
- edit /etc/sysconfig/selinux and add or modify this line:
SELINUX=disabled
- # touch /.relabel
- # systemctl reboot
(and go get a cup of coffee while your filesystem gets relabeled)

before making any metadata changes on a RAID 6 array.

Thanks again, Neil and members of the Linux-RAID community!
-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
