From: Jeff Rippy <jrippy@gmail.com>
Subject: Re: extending raid-5 ?
Date: Sat, 16 May 2009 16:07:11 -0500
Message-ID: <de6d3ea90905161407h457188fdk6c388f1cc5688b65@mail.gmail.com>
References: <795999990.20090511010018@kaneda.iguw.tuwien.ac.at>
	 <1242018671.29072.18.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1242018671.29072.18.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

But don't copy the partition map at the beginning of the drive
otherwise you'll end up with 1.5tb drives that have a 750gb partition.
 Someone confirm but I believe that's the first 512 bytes when copying
with dd.

Jeff

On Mon, May 11, 2009 at 12:11 AM, Redeeman <redeeman@metanurb.dk> wrote=
:
>
> On Mon, 2009-05-11 at 01:00 +0200, Rainer Fuegenstein wrote:
> > hi,
> >
> > I'm currently using a 4*750GB SATA RAID-5 under centos 5.2 (mdadm
> > v2.6.4, kernel 2.6.18-128.1.6.el5) which I need to exend by replaci=
ng
> > the 750GB disks with 1.5TB ones.
> >
> > since the mainboard has only 4 SATA ports, I need to replace one di=
sk
> > after the other. I came up with the following plan:
> >
> > 1) fail first disk
> > =A0 mdadm /dev/md0 -f /dev/sda1
> >
> > 2) remove first disk
> > =A0 mdadm /dev/md0 -r /dev/sda1
> >
> > 3) shutdown the server, unplug 750GB sda drive, plug in 1.5TB drive
>
> If you are going to do downtime anyway, i would suggest you just down
> the box, and then copy the data with dd, that way you should probably=
 be
> able to avoid the costly resync, plus temporary loss of redundancy
>
> > 4) create a linux raid autodetect partition on sda which covers the
> > whole 1.5TB
> >
> > 5) add new device to the raid5 and wait until resync has finished
> > =A0 mdadm /dev/md0 -a /dev/sda1
> >
> > ... repeat steps 1 tp 5 for sdb to sdd
> >
> > 6) grow the raid
> > =A0 mdadm --grow /dev/md0
> >
> > 7) resize the xfs filesystem
> > =A0 =A0xfs_growfs /md0-mount-point
> >
> > is this the proper way to do it, are there any issues I should know
> > about ?
>
> >
> > thnx in advance.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
