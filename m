From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: No response?
Date: Thu, 20 Jan 2005 14:23:28 -0500
Message-ID: <200501201925.j0KJPb912521@www.watkins-home.com>
References: <Pine.LNX.4.58.0501201215420.19586@lewis.et.byu.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0501201215420.19586@lewis.et.byu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: 'David Dougall' <davidd@et.byu.edu>, 'Kanoa Withington' <kanoa@cfht.hawaii.edu>
Cc: 'Mario Holbe' <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At least:
Different SCSI or IDE bus.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Dougall
Sent: Thursday, January 20, 2005 2:18 PM
To: Kanoa Withington
Cc: Mario Holbe; linux-raid@vger.kernel.org
Subject: Re: No response?

By "different controller" do you mean HBA controller or disk controller?
The disk devices are on completely different jbods.  They are both through
the same HBA(the server only has 1 PCI slot)
--David Dougall


On Thu, 20 Jan 2005, Kanoa Withington wrote:

>
> Yes, that's a standard XFS timeout and shutdown. If your second disk
> is on the sme SCSI channel try moving it to a different one,
> preferably a different controller alotgether.
>
> Your disk 08:10 does have real problems, but they are separate from
> the XFS shutdown which should be prevented by the MD layer.
>
> -Kanoa
>
> On Thu, 20 Jan 2005, David Dougall wrote:
>
>
> >  return code = 8000002
> > Jan 10 11:56:08 linux-sg2 kernel: Info fld=0xc7c0181, Current sd08:10:
> > sense key
> >  Hardware Error
> > Jan 10 11:56:08 linux-sg2 kernel:  I/O error: dev 08:10, sector
209453441
> > Jan 10 11:56:08 linux-sg2 kernel: I/O error in filesystem
> > ("device-mapper(254,1)
> > ") meta-data dev device-mapper(254,1) block 0x18fa318f
> > ("xlog_iodone") err
> > or 5 buf count 2048
> > Jan 10 11:56:08 linux-sg2 kernel:
> > xfs_force_shutdown(device-mapper(254,1),0x2) c
> > alled from line 966 of file xfs_log.c.  Return address = 0xc0246d9b
> > Jan 10 11:56:08 linux-sg2 kernel: Filesystem "device-mapper(254,1)": Log
> > I/O Err
> > or Detected.  Shutting down filesystem: device-mapper(254,1)
> > Jan 10 11:56:08 linux-sg2 kernel: Please umount the filesystem, and
> > rectify the
> > problem(s)
> >
> >
> > I don't see any error messages from md in any of these logs.
> > --David Dougall
> >
> >
>
>
>
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

