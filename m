From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: No response?
Date: Thu, 20 Jan 2005 14:18:18 -0500
Message-ID: <200501201920.j0KJKS912497@www.watkins-home.com>
References: <Pine.LNX.4.58.0501201142140.19586@lewis.et.byu.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0501201142140.19586@lewis.et.byu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: 'David Dougall' <davidd@et.byu.edu>, 'Mario Holbe' <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Are you sure it is RAID?  Maybe hardware RAID?

Send the output of these commands:
cat /proc/mdstat
df
mdadm -D /dev/md?

If using LVM:
vgdisplay -v

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Dougall
Sent: Thursday, January 20, 2005 1:57 PM
To: Mario Holbe
Cc: linux-raid@vger.kernel.org
Subject: Re: No response?

The following appears to be relavent information from the syslog file:

Jan 10 11:56:06 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:06 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:06 linux-sg2 kernel:  I/O error: dev 08:10, sector 314179976
Jan 10 11:56:06 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:06 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:06 linux-sg2 kernel:  I/O error: dev 08:10, sector 314179969
Jan 10 11:56:06 linux-sg2 kernel: XFS: device device-mapper(254,1)- XFS
write er
ror in file system meta-data block 0x2bb20008 in device-mapper(254,1)
Jan 10 11:56:07 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:07 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:07 linux-sg2 kernel:  I/O error: dev 08:10, sector 144067
Jan 10 11:56:07 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:07 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:07 linux-sg2 kernel:  I/O error: dev 08:10, sector 62129592
Jan 10 11:56:07 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:07 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:07 linux-sg2 kernel:  I/O error: dev 08:10, sector 144131
Jan 10 11:56:07 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:07 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:07 linux-sg2 kernel:  I/O error: dev 08:10, sector 104726920
Jan 10 11:56:07 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:07 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:07 linux-sg2 kernel:  I/O error: dev 08:10, sector 385
Jan 10 11:56:07 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:07 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:08 linux-sg2 kernel:  I/O error: dev 08:10, sector 157090184
Jan 10 11:56:08 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:08 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:08 linux-sg2 kernel:  I/O error: dev 08:10, sector 209453448
Jan 10 11:56:08 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:08 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:08 linux-sg2 kernel:  I/O error: dev 08:10, sector 343219280
Jan 10 11:56:08 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:08 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:08 linux-sg2 kernel:  I/O error: dev 08:10, sector 392
Jan 10 11:56:08 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:08 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:08 linux-sg2 kernel:  I/O error: dev 08:10, sector 104726913
Jan 10 11:56:08 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:08 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:08 linux-sg2 kernel:  I/O error: dev 08:10, sector 144143
Jan 10 11:56:08 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:08 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:08 linux-sg2 kernel:  I/O error: dev 08:10, sector 157090177
Jan 10 11:56:08 linux-sg2 kernel: SCSI disk error : host 0 channel 0 id 0
lun 47
 return code = 8000002
Jan 10 11:56:08 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
sense key
 Hardware Error
Jan 10 11:56:08 linux-sg2 kernel:  I/O error: dev 08:10, sector 209453441
Jan 10 11:56:08 linux-sg2 kernel: I/O error in filesystem
("device-mapper(254,1)
") meta-data dev device-mapper(254,1) block 0x18fa318f
("xlog_iodone") err
or 5 buf count 2048
Jan 10 11:56:08 linux-sg2 kernel:
xfs_force_shutdown(device-mapper(254,1),0x2) c
alled from line 966 of file xfs_log.c.  Return address = 0xc0246d9b
Jan 10 11:56:08 linux-sg2 kernel: Filesystem "device-mapper(254,1)": Log
I/O Err
or Detected.  Shutting down filesystem: device-mapper(254,1)
Jan 10 11:56:08 linux-sg2 kernel: Please umount the filesystem, and
rectify the
problem(s)


I don't see any error messages from md in any of these logs.
--David Dougall




On Thu, 20 Jan 2005, Mario Holbe wrote:

> David Dougall <davidd@et.byu.edu> wrote:
> > If I am running software raid1 and a disk device starts throwing I/O
> > errors, Is the filesystem supposed to see any indication of this?  I
>
> Usually this should not happen. Presumed a) this device is not the
> only active device in this RAID1 and b) this device is the only
> failing one.
>
> > I have servers with xfs as the filesystem and xfs will start to throw
I/O
> > errors when a disk starts acting up even with software raid in between.
>
> It could be helpful to show the messages appearing (dmesg), the
> RAID setup (cat /proc/mdstat) and the mount (cat /etc/fstab /etc/mtab
> or /proc/mounts).
>
>
> regards,
>    Mario
> --
> <jv> Oh well, config
> <jv> one actually wonders what force in the universe is holding it
> <jv> and makes it working
> <Beeth> chances and accidents :)
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

