From: Karl Voit <news@Karl-Voit.at>
Subject: Re: only 4 spares and no access to my data - solved
Date: Sat, 15 Jul 2006 10:31:40 +0000 (UTC)
Message-ID: <loom.20060715T122344-510@post.gmane.org>
References: <loom.20060709T205013-455@post.gmane.org>  <loom.20060710T095111-275@post.gmane.org>  <44B213CD.5010907@idgmail.se>  <loom.20060710T112944-980@post.gmane.org>  <62b0912f0607100416v51309355v693b5c83ee51fdbc@mail.gmail.com>  <loom.20060710T132722-427@post.gmane.org>  <62b0912f0607100507s21544d12xec9a8bf117b6edc2@mail.gmail.com>  <loom.20060710T142912-798@post.gmane.org>  <62b0912f0607101006k6f9e66cfp86d4f0d0c1de4a3a@mail.gmail.com>  <loom.20060710T211030-179@post.gmane.org> <62b0912f0607121235v5146eafbx84a877899e965c94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Molle Bestefich <molle.bestefich <at> gmail.com> writes:

> My best guess is that it's OK and you won't loose data if you run
> --zero-superblock on /dev/sd[abcd] and then create an array on
> /dev/sd[abcd]1, but I do find it odd that it suddenly can't find
> superblocks on /dev/sd[abcd]1.

OK, I tried several things and then I had enough and I did the creating part:
It worked!

,----[ Creating the raid ]
| root@ned ~ # mdadm --create -n 4 -l 5 /dev/md0 missing /dev/sdb1\
|  /dev/sdc1 /dev/sdd1
| mdadm: /dev/sdb1 appears to be part of a raid array:
|     level=raid5 devices=4 ctime=Sun Jan 29 21:35:05 2006
| mdadm: /dev/sdc1 appears to be part of a raid array:
|     level=raid5 devices=4 ctime=Sun Jan 29 21:35:05 2006
| mdadm: /dev/sdd1 appears to be part of a raid array:
|     level=raid5 devices=4 ctime=Sun Jan 29 21:35:05 2006
| Continue creating array? y
| mdadm: array /dev/md0 started.
| root@ned ~ # date;cat /proc/mdstat
| Fri Jul 14 18:51:48 CEST 2006
| Personalities : [linear] [raid0] [raid1] [raid10] [raid5] [raid4]\
|  [raid6] [multipath]
| md0 : active raid5 sdd1[3] sdc1[2] sdb1[1]
|       732443136 blocks level 5, 64k chunk, algorithm 2 [4/3] [_UUU]
|
| unused devices: <none>
| root@ned ~ #
`----

,----
| root@ned ~ # Start lvm
| Setting up LVM Volume Groups...
|   Reading all physical volumes.  This may take a while...
|   Found volume group "datavg1" using metadata type lvm2
|   1 logical volume(s) in volume group "datavg1" now active
| root@ned ~ # mount /dev/datavg1/datalv1 /data -o ro -t xfs
| root@ned ~ # mount
| rootfs on / type rootfs (rw)
| /dev/root on / type ext3 (rw,data=ordered)
| proc on /proc type proc (rw)
| sysfs on /sys type sysfs (rw)
| /dev/root on /dev/.static/dev type ext3 (rw,data=ordered)
| tmpfs on /dev type tmpfs (rw)
| /dev/pts on /dev/pts type devpts (rw)
| tmpfs on /dev/shm type tmpfs (rw)
| /dev/datavg1/datalv1 on /data type xfs (ro,sunit=128,swidth=25165824)
| root@ned ~ #
`----

OK, the thing works degraded. I unmounted it and did some file 
system checking:

,----
| root@ned ~ # xfs_repair /dev/datavg1/datalv1
| [...]
| done
| xfs_repair /dev/datavg1/datalv1  70.19s user 25.42s system\
|  18% cpu 8:25.58 total
| root@ned ~ # mount /dev/datavg1/datalv1 /data -o ro -t xfs
| root@ned ~ #
`----

No problems were found and the read-only mount afterwards worked.

Now I am doing backups *g*

Thank you for your help!


Next steps:
* After backups, I add the 4th disk
* Praying that the raid runs without problems from now on


