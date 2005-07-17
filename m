From: djani22@dynamicweb.hu
Subject: Re: Found a new bug!
Date: Mon, 18 Jul 2005 00:20:23 +0200
Message-ID: <011f01c58b1d$bb7ef7e0$0400a8c0@LocalHost>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have played more with the 8 TB beast (/dev/md31):

 Try to make the top of it an another type raid.
The raidtools simply refused that. ("file too large")

 But the mdadm allow me to build raid0 from one big drive! (/dev/md31 ->
 /dev/md0)

 But when I try to fill the XFS filesystem on it, after the first 8-10GB,
the
kernel dropped the mount pont.
xfs_repair: http://download.netcenter.hu/raid-bug/xfs.log1

 After xfs_repair, I have mount the md, and almost all file contains
garbage.
RAID allocation problem?

 It is impossible to use >2TB block devices to the raid input?

Janos


> ----- Original Message -----
> From: <djani22@dynamicweb.hu>
> To: <linux-raid@vger.kernel.org>
> Sent: Sunday, July 17, 2005 2:10 PM
> Subject: Found a new bug!
>
>
> > Hi all!
> >
> > I think I found a new bug in the kernel ! (or mdadm?)
> >
> > First I try this:
> > mkraid --configfile /etc/raidtab.nw /dev/md0 -R
> > DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
> > handling MD device /dev/md0
> > analyzing super-block
> > couldn't get device size for /dev/md31 -- File too large
> > mkraid: aborted.
> > (In addition to the above messages, see the syslog and /proc/mdstat as
> well
> >  for potential clues.)
> >
> > Next  I try this:
> >
> > ./create_linear
> > mdadm: /dev/md31 appears to be part of a raid array:
> >     level=0 devices=1 ctime=Sun Jul 17 13:30:27 2005
> > Continue creating array? y
> > ./create_linear: line 1:  2853 Segmentation fault      mdadm --create
> > /dev/md0 --chunk=32 --level=linear --force --raid-devices=1 /dev/md31
> >
> > After this little script the half of the raid subsystem hangs:
> >
> > The raidtools makes nothing, the mdadm makes nothing too.
> > AND the cat /proc/mdstat is hangs too!
> > But the /dev/md31 device is still working.
> >
> > mdstat in previous 2s: (watch cat /proc/mdstat)
> >
> > Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [faulty]
> > md31 : active raid0 md4[3] md3[2] md2[1] md1[0]
> >       7814332928 blocks 32k chunks
> >
> > md4 : active raid1 nbd3[0]
> >       1953583296 blocks [2/1] [U_]
> >
> > md3 : active raid1 nbd2[0]
> >       1953583296 blocks [2/1] [U_]
> >
> > md2 : active raid1 nbd1[0]
> >       1953583296 blocks [2/1] [U_]
> >
> > md1 : active raid1 nbd0[0]
> >       1953583296 blocks [2/1] [U_]
> >
> > unused devices: <none>
> >
> > Kernel: 2.6.13-rc3
> > raidtools-1.00.3
> > mdadm-1.12.0
> >
> > The background:
> > I try to build a big array ~8TB.
> >
> > I use for this 5 PCs.
> > 4 for "disk nodes" with nbd and 1 for "concentrator".
> > (from previous idea in this list. ;)
> > In the concentrator, the first level raid  (md1-4) is for ability to
> backup,
> > swap the disk nodes. (node-spare)
> > The next level (md31) is for the performance. ;)
> > And, the last level (md0 linear) for scalability.
> >
> > Why dont use LVM for last level?
> > Well, I try that, but cat /dev/.../LV >/dev/null can do only 15 - 16
MB/s
> > and cat /dev/md31 >/dev/null can do 34-38MB/s.
> > (the network is G-Ethernet, but only 32bit/33MHz PCI!)
> >
> > Thanks
> > Janos
>

