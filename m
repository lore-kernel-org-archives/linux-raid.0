From: "Brandon Belshaw" <maillists@hosttuls.com>
Subject: RE: Disks keep disapearing
Date: Mon, 12 May 2003 10:31:03 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <01b301c318ac$47c1f180$21dd7e42@admin>
References: <3EBD2D2C.1050900@visiarc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EBD2D2C.1050900@visiarc.com>
To: =?iso-8859-1?Q?'Johan_Sch=F6n'?= <johan.schon@visiarc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




> Peter L. Ashford wrote:
> > WD has had problems similar to this with many of their drives.  It=20
> > just decides to 'go away'.  There is a fix available on=20
> their web site=20
> > for the 180GB and 200GB drives (and a better description of the=20
> > problem), but the problem is NOT limited to those drives.
>=20

> How do these problem appear in log files?

-=3D A server that lost one drive on Sunday, only had this error:

 kernel: end_request: I/O error, dev 03:41 (hdb), sector 512


-=3D Another server that is having this problems, has this in the logs:

May  1 03:01:28 virt10p kernel: end_request: I/O error, dev 16:42 (hdd)=
,
sector 16
May  1 03:01:28 virt10p kernel: hdd: status error: status=3D0x10 {
SeekComplete }
( repet 10 times)
May  1 03:01:28 virt10p kernel: hdd: status error: status=3D0x10 {
SeekComplete }
May  1 03:01:28 virt10p kernel: end_request: I/O error, dev 16:42 (hdd)=
,
sector 108736
May  1 04:02:13 virt10p kernel: hdd: status error: status=3D0x10 {
SeekComplete }
May  1 04:02:13 virt10p kernel: hdd: status error: status=3D0x10 {
SeekComplete }



>=20
> I have a machine with two Promise Ultra100 TX2 cards, and=20
> five WD2000JB 200 GB drives in RAID-5. In a month, i've had a=20
> few disk "failures" that typically looks like this in the logs:
>=20
[snip log]

> The disk itself doesn't appear to know about any failures=20
> (using smartctl), and it works again when hotadded to the=20
> raidset. I've also had a multiple drive "failure" twice, both=20
> times with two drives using the same IDE channel.

On the server with the most recent crash, I replaced the drive with a
WD1200JB (it was a WD1200BB), rebuilt the array, then formated the driv=
e
that wasn=92t replaced checking it for badblocks, using the slower,
destructive, read-write test (they arnt kidding about the slower part,
took about 24 hours).

Up until Sunday, I could readd the disk to the array, but now the 2nd
hard drive doesn't even show up when doing a fdisk -l




> I'm not sure if these problems are caused by buggy Promise=20
> ATA drivers in my kernel (RH9, 2.4.20) or the WDC problem=20
> with 180/200 GB drives.  From WDC's description of the=20
> problem, I got the impression that it only happened when the=20
> drives were connected to hardware RAID cards like 3Ware IDE=20
> raid controllers.

I've contacted WD's tech support to see how they can help.  When I'm
done with them I'll post the results.


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
