From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: comparing FreeBSD to linux
Date: Mon, 21 Nov 2005 12:33:18 -0500
Message-ID: <200511211733.jALHXGE01893@www.watkins-home.com>
References: <5d96567b0511210647n144bcda6p53d2eb9ba20a8ebc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0511210647n144bcda6p53d2eb9ba20a8ebc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Raz Ben-Jehuda(caro)'" <raziebe@gmail.com>
Cc: 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Raz Ben-Jehuda(caro)
> Sent: Monday, November 21, 2005 9:47 AM
> To: Guy
> Cc: Linux RAID Mailing List
> Subject: Re: comparing FreeBSD to linux
> 
> fetching from a disk a random block of 1 MB is aproximately
> 20MB/s for a sata disk ( randomly , all over the disk and over a file
> system).
> god help us if the cpu what that slow.

If your CPU load is 90% at 20MB/sec then you have a problem.

I get about 56MB per sec on my filesystem which is on a RAID5.
The CPU load is less than 50%
I have a P3-500MHz 2 CPU system.  VERY OLD!

I have Linux 2.4.31.  I don't know if the newer 2.6 is better or not.

Guy

> 
> On 11/21/05, Guy <bugzilla@watkins-home.com> wrote:
> > > -----Original Message-----
> > > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > > owner@vger.kernel.org] On Behalf Of Raz Ben-Jehuda(caro)
> > > Sent: Sunday, November 20, 2005 6:50 AM
> > > To: Linux RAID Mailing List
> > > Subject: comparing FreeBSD to linux
> > >
> > > I have evaluated which is better in terms cpu load when dealing with
> raid.
> > > FreeBSD vinum's or linux raid.
> > > When i issued a huge amount of io's read to linux raid i got 93% cpu
> > > load ( 7% idle),
> > > while i having 10% cpu load  ( 90% idle ) in the freebsd.
> >
> > Maybe a silly question...  But is it 9.3 times faster under Linux?  :)
> > That would explain the 9.3 times increase in CPU load.
> >
> > It is important that you are comparing the CPU load at the same disks
> rate,
> > or at least factor in the disk rate.
> >
> > Guy
> >
> > >
> > > I need to switch to linux from freebsd. I am using in linux 2.6.6
> kernel .
> > > is problem is a known issue in linux , is it fixed ?
> > >
> > > --
> > > Raz
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> --
> Raz
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

