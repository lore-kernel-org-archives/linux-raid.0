From: "David Lethe" <david@santools.com>
Subject: RE:  Re: RFC: detection of silent corruption via ATA long sector reads
Date: Fri, 26 Dec 2008 18:32:56 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C031B27E3@34093-C3-EVS3.exchange.rackspace.com>
References: <87f94c370812261344s3f70de25r4d132101d2247e00@mail.gmail.com> A<49555797.3080009@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: A<49555797.3080009@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Hancock <hancockr@shaw.ca>, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Robert Hancock
> Sent: Friday, December 26, 2008 4:16 PM
> To: linux-raid@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: RFC: detection of silent corruption via ATA long sector
> reads
> 
> Greg Freemyer wrote:
> > All,
> >
> > On the mdraid list, there was a recent thread about using raid
> > functionality to detect / repair silent corruption.
> >
> > The issues brought up were that a lot of silent data corruption
> occurs
> > when cables, controllers, power supplies, ram, cache, etc. goes bad.
> >
> > It made me think about another option for detecting silent
corruption
> > I have not seen discussed, but maybe I missed it.
> >
> > Aiui, the ATA spec allows for the reading of a long sector as well
as
> > the normal 512 byte sector.  When you get a long sector you also get
> > the CRC (or whatever checksum data there is on the disk that allows
> > the drive itself to detect media errors).
> >
> > I don't have any idea how easy or hard it would be to do, but I
would
> > like to see the entire block subsystem enhanced to optionally allow
> > long sector reads to be used in a "paranoid" fashion.
> >
> > Effectively it would be:
> >
> > 1) Read long sector from drive:  verify CRC in kernel.  This tests
> > most everything on the i/o path.
> >
> > 2) maintain CRC type information in block subsystem.  Verify no
> > corruption just before handing off to userspace.  This would
> > potentially identify CPU/cache/RAM failures.
> 
> Even if the drive supports those commands the problem is the CRC/ECC
> data is in a vendor-specific format, so it couldn't be processed
> generically.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Many of the RAID appliance/subsystem vendors format the disks to 520 or
528
Bytes/sector, but expose 512-byte blocks to the user.  The ECC logic is
done
by the firmware ... or if this ever gets implemented, would be done by
the
LINUX kernel.  True there are some issues with many of the cheap
consumer
class drives not supporting anything but 512-byte blocks, but we
shouldn't
code to lowest common denominator.

With 1TB SATA disks selling for $99, then it isn't as if the extra 8-16
bytes
for ECC on the disk drive is going to be a problem.

David



