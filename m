From: Xiao Ni <xni@redhat.com>
Subject: Re: raid5 reshape is stuck
Date: Wed, 27 May 2015 08:04:24 -0400 (EDT)
Message-ID: <476656362.5105083.1432728264276.JavaMail.zimbra@redhat.com>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com> <1822959676.2432469.1432211518647.JavaMail.zimbra@redhat.com> <20150525135001.43d1083a@notabene.brown> <427651758.4121803.1432637303447.JavaMail.zimbra@redhat.com> <20150527100253.221ab553@notabene.brown> <20150527111004.5f136f23@notabene.brown> <2129908770.5092770.1432726084717.JavaMail.zimbra@redhat.com> <20150527213449.6e017deb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150527213449.6e017deb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Wednesday, May 27, 2015 7:34:49 PM
> Subject: Re: raid5 reshape is stuck
> 
> On Wed, 27 May 2015 07:28:04 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> 
> 
> > [root@intel-waimeabay-hedt-01 mdadm]# cat
> > /usr/lib/systemd/system/mdadm-grow-continue\@.service
> > #  This file is part of mdadm.
> > #
> > #  mdadm is free software; you can redistribute it and/or modify it
> > #  under the terms of the GNU General Public License as published by
> > #  the Free Software Foundation; either version 2 of the License, or
> > #  (at your option) any later version.
> > 
> > [Unit]
> > Description=Manage MD Reshape on /dev/%I
> > DefaultDependencies=no
> > 
> > [Service]
> > ExecStart=/usr/sbin/mdadm --grow --continue /dev/%I
> > --backup-file=/root/tmp0
> 
> Please remove the ---backup-file=/root/tmp0 for further testing.  The patch I
> provided should make that unnecessary.
> 
> > StandardInput=null
> > StandardOutput=null
> > StandardError=null
> 
> Could you try removing these - that might allow error messages to appear.
> I wonder why I included them - they shouldn't be needed.
> 
> Thanks,
> NeilBrown
> 
> 

[root@intel-waimeabay-hedt-01 mdadm]# mdadm -CR /dev/md0 -l5 -n4 /dev/loop[0-3] --assume-clean
mdadm: /dev/loop0 appears to be part of a raid array:
       level=raid5 devices=5 ctime=Wed May 27 02:45:08 2015
mdadm: /dev/loop1 appears to be part of a raid array:
       level=raid5 devices=5 ctime=Wed May 27 02:45:08 2015
mdadm: /dev/loop2 appears to be part of a raid array:
       level=raid5 devices=5 ctime=Wed May 27 02:45:08 2015
mdadm: /dev/loop3 appears to be part of a raid array:
       level=raid5 devices=5 ctime=Wed May 27 02:45:08 2015
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
[root@intel-waimeabay-hedt-01 mdadm]# mdadm /dev/md0 -a /dev/loop4 
mdadm: added /dev/loop4
[root@intel-waimeabay-hedt-01 mdadm]# mdadm --grow /dev/md0 --raid-devices=5
mdadm: Need to backup 6144K of critical section..
[root@intel-waimeabay-hedt-01 mdadm]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md0 : active raid5 loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
      1532928 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
      [>....................]  reshape =  0.0% (0/510976) finish=532.2min speed=0K/sec
      
unused devices: <none>
[root@intel-waimeabay-hedt-01 mdadm]# cat /usr/lib/systemd/system/mdadm-grow-continue\@.service 
#  This file is part of mdadm.
#
#  mdadm is free software; you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.

[Unit]
Description=Manage MD Reshape on /dev/%I
DefaultDependencies=no

[Service]
ExecStart=/usr/sbin/mdadm --grow --continue /dev/%I 
#StandardInput=null
#StandardOutput=null
#StandardError=null
KillMode=none


The problem still exist. And there are messages in /var/log/messages

May 27 08:03:29 intel-waimeabay-hedt-01 systemd: mdadm-grow-continue@md0.service: main process exited, code=exited, status=1/FAILURE
May 27 08:03:29 intel-waimeabay-hedt-01 systemd: Unit mdadm-grow-continue@md0.service entered failed state.

Xiao



