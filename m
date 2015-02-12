From: sunruh@prismnet.com
Subject: Re: please help - raid 1 degraded
Date: Wed, 11 Feb 2015 19:02:00 -0600
Message-ID: <20150212010200.GA51009@eris.prismnet.com>
References: <20150211180403.GA14805@fnord.prismnet.com>
 <54DBD3E2.80701@websitemanagers.com.au>
 <20150212000940.GA49579@eris.prismnet.com>
 <54DBF587.6050004@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54DBF587.6050004@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: sunruh@prismnet.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 12, 2015 at 11:36:23AM +1100, Adam Goryachev wrote:
> On 12/02/15 11:09, sunruh@prismnet.com wrote:
> > On Thu, Feb 12, 2015 at 09:12:50AM +1100, Adam Goryachev wrote:
> >> On 12/02/15 05:04, sunruh@prismnet.com wrote:
> >>> centos 6.6
> >>> 2x 240gig ssd in raid1
> >>> this is a live running production machine and the raid1 is for /u of
> >>> users home dirs.
> >>>
> >>> 1 ssd went totally offline and i replaced it after noticing the firmware
> >>> levels are not the same.  the new ssd has the same level firmware.
> >>>
> >>> /dev/sdb is the good ssd
> >>> /dev/sdc is the new blank ssd
> >>>
> >>> when working it was /u1 from /dev/md127p1 and /u2 from /dev/md127p2
> >>> p1 is 80gig and p2 is 160gig for the full 240gig size of the ssd
> >>>
> >>>> ls -al /dev/md*
> >>> brw-rw---- 1 root disk   9, 127 Feb 11 11:09 /dev/md127
> >>> brw-rw---- 1 root disk 259,   0 Feb 10 20:23 /dev/md127p1
> >>> brw-rw---- 1 root disk 259,   1 Feb 10 20:23 /dev/md127p2
> >>>
> >>> /dev/md:
> >>> total 8
> >>> drwxr-xr-x  2 root root  140 Feb 10 20:24 .
> >>> drwxr-xr-x 20 root root 3980 Feb 10 20:24 ..
> >>> lrwxrwxrwx  1 root root    8 Feb 11 11:09 240ssd_0 -> ../md127
> >>> lrwxrwxrwx  1 root root   10 Feb 10 20:23 240ssd_0p1 -> ../md127p1
> >>> lrwxrwxrwx  1 root root   10 Feb 10 20:23 240ssd_0p2 -> ../md127p2
> >>> -rw-r--r--  1 root root    5 Feb 10 20:24 autorebuild.pid
> >>> -rw-------  1 root root   63 Feb 10 20:23 md-device-map
> >>>
> >>>> ps -eaf | grep mdadm
> >>> root      2188     1  0 Feb10 ?        00:00:00 mdadm --monitor --scan -f --pid-file=/var/run/mdadm/mdadm.pid
> >>>
> >>> how do i rebuild /dev/sdc into the mirror of /dev/sdb?
> >>>
> >> Please send the output of fdisk -lu /dev/sd[bc] and cat /proc/mdstat
> >> (preferably both when it was working and current).
> >>
> >> In general, when replacing a failed RAID1 disk, and assuming you
> >> configured it the way I think you did:
> >> 1) fdisk -lu /dev/sdb
> >> Find out the exact partition sizes
> >> 2) fdisk /dev/sdc
> >> Create the new partitions exactly the same as /dev/sdb
> >> 3) mdadm --manage /dev/md127 --add /dev/sdb1
> >> Add the partition to the array
> >> 4) cat /proc/mdstat
> >> Watch the rebuild progress, once it is complete, relax.
> >>
> >> PS, steps 1 and 2 may not be needed if you are using the full block
> >> device instead of a partition. Also, change the command in step 3 to
> >> "mdadm --manage /dev/md127 --add /dev/sdb"
> >>
> >> PPS, if this is a bootable disk, you will probably also need to do
> >> something with your boot manager to get that installed onto the new disk
> >> as well.
> >>
> >> Hope this helps, otherwise, please provide more information.
> >>
> >>
> >> Regards,
> >> Adam
> >>
> >> -- 
> >> Adam Goryachev Website Managers www.websitemanagers.com.au
> > Adam (and anybody else that can help),
> > after issue i do not have before. and no they are not bootable.
> >
> > [root@shell ~]# fdisk -lu /dev/sd[bc]
> >
> > Disk /dev/sdb: 240.1 GB, 240057409536 bytes
> > 255 heads, 63 sectors/track, 29185 cylinders, total 468862128 sectors
> > Units = sectors of 1 * 512 = 512 bytes
> > Sector size (logical/physical): 512 bytes / 512 bytes
> > I/O size (minimum/optimal): 512 bytes / 512 bytes
> > Disk identifier: 0x0001a740
> >
> >
> > Disk /dev/sdc: 240.1 GB, 240057409536 bytes
> > 255 heads, 63 sectors/track, 29185 cylinders, total 468862128 sectors
> > Units = sectors of 1 * 512 = 512 bytes
> > Sector size (logical/physical): 512 bytes / 512 bytes
> > I/O size (minimum/optimal): 512 bytes / 512 bytes
> > Disk identifier: 0x00000000
> >
> > [root@shell ~]# cat /proc/mdstat
> > Personalities : [raid1]
> > md127 : active raid1 sdb[2]
> >        234299840 blocks super 1.2 [2/1] [U_]
> >        
> > unused devices: <none>
> 
> > i dont seem to be seeing the partition sizes or im stupid.
> > couldnt i just dd if=/dev/sdb of=/dev/sdc bs=1G count=240 and then do the
> > mdadm?
> OK, so you aren't using partitioned disks, so it is as simple as what I 
> said above (with one minor correction):
> 
> "mdadm --manage /dev/md127 --add /dev/sdc"
> 
> 
> /dev/sdc is the new blank ssd, so that is the one to add, the above 
> command with /dev/sdb wouldn't have done anything at all .... So just 
> run that command, and then do "watch cat /proc/mdstat" until the good 
> stuff is completed.
> 
> Regards,
> Adam
> 
> -- 
> Adam Goryachev Website Managers www.websitemanagers.com.au

awesome sauce!
it is recovering and at a fast pace too.  says it will be done in 16mins.

ok, so now the really important questions:
once done, what files/stats do i need to save off for the next time it 
craters?
