From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: raid 0 read performance
Date: Thu, 29 Dec 2005 13:32:25 +0200
Message-ID: <5d96567b0512290332u481a61cbn7d03f65761ca0916@mail.gmail.com>
References: <5d96567b0512290210q2f4b63c5tc91a49523c93e4df@mail.gmail.com>
	 <20051229110413.GD17602@earth.overmeer.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051229110413.GD17602@earth.overmeer.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

what "wrt" stands for ?

On 12/29/05, Mark Overmeer <solutions@overmeer.net> wrote:
> * Raz Ben-Jehuda(caro) (raziebe@gmail.com) [051229 10:10]:
> > I have tested the overhead of linux raid0.
> > I used two scsi atlas maxtor disks ( 147 MB) and combined them to single
> > raid0 volume.
> > The raid is striped in 256K stripes.
>
> Are you sure you tested "linux" overhead?  Maybe you have just tested raid0
> properties.
>
> > I filled the raid0 up to the maximum with files over xfs file system.
> > I've checked the peformance of reading 60 files like that:
> >
> > while need to read
> >  for every file
> >      read 0.5 M from file
> >
> > I got 50 MB/s .
> >
> > Armed with this knowledge i went and did the same test over
> > one disk and i got 32 MB/s .
> >
> > Question:
> >  why is this perfomance drop ?
>
> Good performance for such small reads wrt the block-size...
> Ok, simple calculation:
>   seek time average for one disk is half a rotation
>   for two disks   1 - (1-0.5)*(1-0.5) = 0.75 rotation
>
> Without taking into account the time to do actual reads:
>   0.5/0.75  * (2x32MB/s) = 43MB/s     (34% performance drop)
>
> The only effect you see is that the probability that both disks are in
> optimal position to read from them decreases.
>
> Solution: take very large files wrt the stripe-size to get double
> performance.  Or take files smaller than the stripe-size.
>
> Of course, there can be other reasons which can reduce the performance
> as well.  However, I achieve 200MB/s over 4 striped disk each capable
> of 50MB/s for huge files and 64K stipes... Linux doesn't seem to be the
> bottleneck in my setup.
> --
> Regards,
>                MarkOv
>
> ------------------------------------------------------------------------
>        Mark Overmeer MSc                                MARKOV Solutions
>        Mark@Overmeer.net                          solutions@overmeer.net
> http://Mark.Overmeer.net                   http://solutions.overmeer.net
>
>


--
Raz
