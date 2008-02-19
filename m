From: Iustin Pop <iusty@k1024.org>
Subject: Re: LVM performance (was: Re: RAID5 to RAID6 reshape?)
Date: Tue, 19 Feb 2008 21:00:48 +0100
Message-ID: <20080219200048.GB7693@teal.hq.k1024.org>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com> <18360.8065.335494.142060@tree.ty.sabi.co.UK> <20080217074526.29d3c5c5@hardcode42.net> <20080218062604.05ae4821@szpak> <aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com> <20080218154203.6e2d1483@szpak> <47BB30DF.1080006@student.tuwien.ac.at> <cccedfc60802191152k11f0f093gf26e42ed7d888c6d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60802191152k11f0f093gf26e42ed7d888c6d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Oliver Martin <oliver.martin@student.tuwien.ac.at>, Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 19, 2008 at 01:52:21PM -0600, Jon Nelson wrote:
> On Feb 19, 2008 1:41 PM, Oliver Martin
> <oliver.martin@student.tuwien.ac.at> wrote:
> > Janek Kozicki schrieb:
> >
> > $ hdparm -t /dev/md0
> >
> > /dev/md0:
> >   Timing buffered disk reads:  148 MB in  3.01 seconds =  49.13 MB/sec
> >
> > $ hdparm -t /dev/dm-0
> >
> > /dev/dm-0:
> >   Timing buffered disk reads:  116 MB in  3.04 seconds =  38.20 MB/sec
> 
> I'm getting better performance on a LV than on the underlying MD:
> 
> # hdparm -t /dev/md0
> 
> /dev/md0:
>  Timing buffered disk reads:  408 MB in  3.01 seconds = 135.63 MB/sec
> # hdparm -t /dev/raid/multimedia
> 
> /dev/raid/multimedia:
>  Timing buffered disk reads:  434 MB in  3.01 seconds = 144.04 MB/sec
> #

As people are trying to point out in many lists and docs: hdparm is
*not* a benchmark tool. So its numbers, while interesting, should not be
regarded as a valid comparison.

Just my oppinion.

regards,
iustin
