From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Port Multipliers
Date: Wed, 16 Sep 2009 10:35:29 -0500
Message-ID: <20090916153545511.YYST11918@cdptpa-omta04.mail.rr.com>
References: <20C809AA-01E5-4402-928C-84F46F2489B9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20C809AA-01E5-4402-928C-84F46F2489B9@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Doug Ledford
> Sent: Wednesday, September 16, 2009 9:28 AM
> To: Tom Carlson
> Cc: Majed B.; David Rees; Richard Scobie; Greg Freemyer; Drew; Linux RAID
> Mailing List
> Subject: Re: Port Multipliers
> 
> On Sep 16, 2009, at 7:11 AM, Tom Carlson wrote:
> > Hi,
> >
> > I've had a slightly bad experience with port multipliers. I have a
> > PCI-e x1 JMB362 on the host end and a SiI 3726 connected to it. (I
> > think. It's a 1-5 PM). I have 5 disks connected in raid5 and get some
> > fairly appalling write speeds, well below what I'd expect even for
> > raid5 writes. Reads too are fairly slow...
> >
> > $ dd if=/dev/zero of=./blah bs=1M count=512
> > 512+0 records in
> > 512+0 records out
> > 536870912 bytes (537 MB) copied, 47.4814 s, 11.3 MB/s
> >
> > $ dd if=./bigfile.iso of=/dev/null
> > 8474857+0 records in
> > 8474857+0 records out
> > 4339126272 bytes (4.3 GB) copied, 144.667 s, 30.0 MB/s
> >
> > Obviously this isn't the most scientific of tests... :-) but it does
> > show slowness with this particular combination.
> >
> > I'm tempted to go buy a SiI 3132 based controller and compare the
> > results.
> 
> 
> I would, those numbers look *really* bad compared to what they could be.

	Um, yeah. No kidding.  I did the same tests on a very "low rent"
system using a mid-range Asus / AMD 64 x 2 motherboard and a $45 three port
Chinese clone SiI 3124 interface card feeding a ten disk RAID6 array:

RAID-Server:/RAID/Server-Main/Temp# dd if=/dev/zero of=./blah bs=1M
count=512
512+0 records in
512+0 records out
536870912 bytes (537 MB) copied, 16.0076 s, 33.5 MB/s
RAID-Server:/RAID/Server-Main/Temp# dd if=Test_HD.TiVo of=/dev/null
3952838+1 records in
3952838+1 records out
2023853135 bytes (2.0 GB) copied, 19.4791 s, 104 MB/s

	And from cached data:

RAID-Server:/RAID/Server-Main/Temp# dd if=./blah of=/dev/null
1048576+0 records in
1048576+0 records out
536870912 bytes (537 MB) copied, 1.51728 s, 354 MB/s

	Doing ordinary daily rsync backups between two similar systems
across a 1000BaseT LAN I regularly hit peaks of 75 MB/s with sustained rates
well above 50 MB/s.

