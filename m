From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid 10 or 1+0 ?
Date: Mon, 25 Apr 2005 17:48:33 -0400
Message-ID: <200504252148.j3PLmcm00554@www.watkins-home.com>
References: <E3B0B2160F552B408D3655883F58C14490CC@cinshrexc02.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E3B0B2160F552B408D3655883F58C14490CC@cinshrexc02.shermfin.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Andrew Rechenberg Lists' <flux-ml@sfg.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

No, the question was not related to RAID0+1.
I my opinion, RAID0+1 would be evil!
RAID1+0 or md's RAID10 would be much better.

Guy


> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Andrew Rechenberg Lists
> Sent: Monday, April 25, 2005 4:05 PM
> To: linux-raid@vger.kernel.org
> Subject: RE: raid 10 or 1+0 ?
> 
> The subject of the mail should be "raid 10 or 0+1" I believe :)
> 
> According to acnc.com:
> 
> http://www.acnc.com/04_01_10.html
> 
> "RAID 10 is implemented as a striped array whose segments are RAID 1
> arrays "
> 
> http://www.acnc.com/04_01_0_1.html
> 
> "RAID 0+1 is implemented as a mirrored array whose segments are RAID 0
> arrays"
> 
> If a drive were to fail in a RAID0+1, what you are left with is
> essentially one RAID0 array.
> 
> You want to use RAID10 if you need high performance and very good fault
> tolerance.  The disadvantage is that you end up with half of the
> available raw space as useable.
> 
> I've never seen nor tried a "/" file system on RAID10 or RAID0+1.  What
> I usually hear recommended is /boot and or / on RAID1 and then if you
> need better performance for a database or other application, then create
> a /data partition or something of the sort on a separate RAID10 array
> that is on different disk spindles.
> 
> Here is our configuration:
> 
> /: RAID1
> /backup: RAID0 disk backup staging area
> /data: LVM on a 56 SCSI disk SW RAID10 array
> 
> 
> HTH,
> Andy.
> 
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org
> > [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Andre Noll
> > Sent: Sunday, April 24, 2005 9:54 AM
> > To: linux-raid@vger.kernel.org
> > Subject: Re: raid 10 or 1+0 ?
> >
> > On Sat, 23 Apr 2005 12:21:17 -0400 you wrote in
> > local.lists.linux-raid:
> >
> > > Maybe we need some success stories for RAID10 and RAID1+0
> > mounted on "/".
> >
> > I have such a setup up and running for quite some time now:
> >
> > cat /proc/mdstat
> > Personalities : [raid0] [raid1]
> > md3 : active raid0 md1[0] md2[1]
> >       156247808 blocks 64k chunks
> >
> > md2 : active raid1 hda2[0] hdk2[1]
> >       78123968 blocks [2/2] [UU]
> >
> > md1 : active raid1 hdc2[0] hdg2[1]
> >       78123968 blocks [2/2] [UU]
> >
> > md0 : active raid1 hdc1[2] hda1[3] hdk1[1] hdg1[0]
> >       49280 blocks [4/4] [UUUU]
> >
> > My roottfs is on a lv. The corresponding vg is made from md3.
> >
> > This works if you do not rely on the kernel to assemble your
> > array but use an initrd to achieve this.
> >
> > Just use something like this in your linuxrc, right after
> > creating the device nodes (if you use udev):
> >
> > 	if test -e /proc/mdstat; then
> > 		log "scanning for multi disk devices"
> > 		echo "DEVICE /dev/hd[a-z] /dev/sd[a-z]
> > /dev/md[0-9]" > /etc/mdadm.conf
> > 		mdadm --examine --scan --config=/etc/mdadm.conf \
> > 			>> /etc/mdadm.conf
> > 		mdadm --assemble --scan
> > 	fi
> >
> > 	if test -c /dev/mapper/control; then
> > 		log "setting up lvm"
> > 		vgscan --mknodes
> > 		vgchange -a y
> > 	fi
> >
> >
> > BTW, you should definitively use striped mirrors rather than
> > mirrored stripes.
> >
> > However, note that you can not boot from a striped mirror.
> > That is, you need a tiny partition, preferably at the
> > beginning of your discs, to store the kernel image and the
> > initrd, but not the rootfs. You can make it a raid1 over all
> > disks, like my md0 above, and use lilo to write a mbr to
> > _all_ discs. That way you can shuffle around your discs and
> > your system will still boot.
> >
> > More details on request ;)
> > Andre
> > --
> > Andre Noll, http://www.mathematik.tu-darmstadt.de/~noll
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-raid" in the body of a message to
> > majordomo@vger.kernel.org More majordomo info at
> > http://vger.kernel.org/majordomo-info.html
> >
> Confidentiality Notice: This e-mail message including attachments, if any,
> is intended
> only for the person or entity to which it is addressed and may contain
> confidential
> and/or privileged material. Any unauthorized review, use, disclosure or
> distribution
> is prohibited. If you are not the intended recipient, please contact the
> sender by reply
> e-mail and destroy all copies of the original message. If you are the
> intended recipient,
> but do not wish to receive communications through this medium, please so
> advise the
> sender immediately.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

