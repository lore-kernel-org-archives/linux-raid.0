From: "A.J.Dawson" <A.J.Dawson@Bradford.ac.uk>
Subject: RE: Disks keep disapearing
Date: Mon, 12 May 2003 18:49:09 +0100 (GMT Daylight Time)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.WNT.4.44.0305121839360.5328-100000@ender>
References: <01b301c318ac$47c1f180$21dd7e42@admin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <01b301c318ac$47c1f180$21dd7e42@admin>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have also experienced the problem with a set of WD 120Gb disks attach=
ed
to an Adaptec 2400A RAID controller.  The drives are WD1200JB's and sho=
w
the same sort of behaviour as others on the list have described (and
incidentally as described in answer 913 of the WD knowledge base), i.e.
the array runs fine for a while, then suddenly for no apparent reason a
disk vanishes from the array.

In the 2400A's BIOS, the disk that has dropped from the array shows its=
elf
typically as a 'missing component'.  Zapping the drive and/or writing
zeros to the drive does not allow the drive to be re-inserted in the
array (after doing a thorough check that in fact the disk *is* okay) - =
the
array has to be rebuilt from scratch every time!  The log shows that th=
e
drive timed-out when the RAID controller attempted to access it and so =
the
controller takes the disk off-line assuming it is faulty.

I've followed the advice in the knowledge base article and updated the
firmware on each of the drives used (8 at the moment as we have two
servers using them) to remove the acoustic noise reduction stuff - I'll
let you know how I get on!

Regards
Andy


On Mon, 12 May 2003, Brandon Belshaw wrote:

>
>
>
> > Peter L. Ashford wrote:
> > > WD has had problems similar to this with many of their drives.  I=
t
> > > just decides to 'go away'.  There is a fix available on
> > their web site
> > > for the 180GB and 200GB drives (and a better description of the
> > > problem), but the problem is NOT limited to those drives.
> >
>
> > How do these problem appear in log files?
>
> -=3D A server that lost one drive on Sunday, only had this error:
>
>  kernel: end_request: I/O error, dev 03:41 (hdb), sector 512
>
>
> -=3D Another server that is having this problems, has this in the log=
s:
>
> May  1 03:01:28 virt10p kernel: end_request: I/O error, dev 16:42 (hd=
d),
> sector 16
> May  1 03:01:28 virt10p kernel: hdd: status error: status=3D0x10 {
> SeekComplete }
> ( repet 10 times)
> May  1 03:01:28 virt10p kernel: hdd: status error: status=3D0x10 {
> SeekComplete }
> May  1 03:01:28 virt10p kernel: end_request: I/O error, dev 16:42 (hd=
d),
> sector 108736
> May  1 04:02:13 virt10p kernel: hdd: status error: status=3D0x10 {
> SeekComplete }
> May  1 04:02:13 virt10p kernel: hdd: status error: status=3D0x10 {
> SeekComplete }
>
>
>
> >
> > I have a machine with two Promise Ultra100 TX2 cards, and
> > five WD2000JB 200 GB drives in RAID-5. In a month, i've had a
> > few disk "failures" that typically looks like this in the logs:
> >
> [snip log]
>
> > The disk itself doesn't appear to know about any failures
> > (using smartctl), and it works again when hotadded to the
> > raidset. I've also had a multiple drive "failure" twice, both
> > times with two drives using the same IDE channel.
>
> On the server with the most recent crash, I replaced the drive with a
> WD1200JB (it was a WD1200BB), rebuilt the array, then formated the dr=
ive
> that wasn=92t replaced checking it for badblocks, using the slower,
> destructive, read-write test (they arnt kidding about the slower part=
,
> took about 24 hours).
>
> Up until Sunday, I could readd the disk to the array, but now the 2nd
> hard drive doesn't even show up when doing a fdisk -l
>
>
>
>
> > I'm not sure if these problems are caused by buggy Promise
> > ATA drivers in my kernel (RH9, 2.4.20) or the WDC problem
> > with 180/200 GB drives.  From WDC's description of the
> > problem, I got the impression that it only happened when the
> > drives were connected to hardware RAID cards like 3Ware IDE
> > raid controllers.
>
> I've contacted WD's tech support to see how they can help.  When I'm
> done with them I'll post the results.
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Dr. Andy Dawson
A.J.Dawson@Bradford.ac.uk
http://www.mossie.org
http://www.museum-explorer.org.uk

 Never attribute to malice that which is adequately explained by stupid=
ity.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
