From: djani22@dynamicweb.hu
Subject: Re: RAID5 question.
Date: Thu, 4 Aug 2005 18:43:10 +0200
Message-ID: <02e301c59913$a226b040$0400a8c0@LocalHost>
References: <17137.43778.476908.961140@cse.unsw.edu.au> <01f001c598fd$c59a51a0$0400a8c0@LocalHost> <1123164866.8854.0.camel@localhost.localdomain> <42F22C8F.4000407@dgreaves.com>  <025301c5990b$8b456cc0$0400a8c0@LocalHost> <1123171018.9269.1.camel@localhost.localdomain> <027f01c5990f$6e8200e0$0400a8c0@LocalHost> <1123172736.9411.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Raz Ben Jehuda <razb@bitband.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The answer is more difficult!

I use RAID-s in 3 layers!

Layer 1 : (RAID5 in 11+1 raw disk in 1 pc) x4 (4 disk nodes)
Layer 2 : RAID1 4x 1/2 nodes (only for ability to backup complete nodes)
Layer 3 : RAID0 to 4 nodes -> 1 big 8TB disk. :-)

I use gnbd for this.
The gnbd sends only small packets, and I think, the too much readahead is
the problem, because the whole 8TB array is phisically stripped to 44 raw
disks, but NOT!
When I disable the readahead, the performace is more worse.
Now  I grow the readahead in the raw disk to 1MB, the raid5 to 10MB, the
raid1 to 1MB, and the raid0 to 8MB, and the performance is great now! :-)

(web+ftp  server for ~200-300 people at one time, downloading a lot of
small(1-60KB) and big (~15-50MB) files)

Thansk for you all!

----- Original Message -----
From: "Raz Ben Jehuda" <razb@bitband.com>
To: <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, August 04, 2005 6:25 PM
Subject: Re: RAID5 question.


> how is the disks performance ? is it OK ?
>
> On Thu, 2005-08-04 at 18:13 +0200, djani22@dynamicweb.hu wrote:
> > Yes, it is there, I know it.
> > But its only for resync or not? :-)
> >
> > ----- Original Message -----
> > From: "Raz Ben Jehuda" <razb@bitband.com>
> > To: <djani22@dynamicweb.hu>
> > Cc: "David Greaves" <david@dgreaves.com>; <linux-raid@vger.kernel.org>
> > Sent: Thursday, August 04, 2005 5:56 PM
> > Subject: Re: RAID5 question.
> >
> >
> > > take a look at /proc/sys/dev/raid/speed_limit_max . it is kilobytes if
i
> > > recall correctly.
> > >
> > > On Thu, 2005-08-04 at 17:45 +0200, djani22@dynamicweb.hu wrote:
> > > > Thanks a lot for you, and Raz!
> > > >
> > > > The raw devices readahead I already set with the hdparm, and
> > > > /sys/block/*/queue/read_ahead_kb, but the md device is only
changeable
> > with
> > > > blockdev. :-)
> > > > I dont use lvm, because it is too slow for me....
> > > >
> > > > But unfortunately the problem is still here for me. :(
> > > > I continue searching the bottleneck...
> > > >
> > > > Thanks!
> > > >
> > > > Janos
> > > >
> > > > ----- Original Message -----
> > > > From: "David Greaves" <david@dgreaves.com>
> > > > To: "Raz Ben Jehuda" <razb@bitband.com>
> > > > Cc: <djani22@dynamicweb.hu>; <linux-raid@vger.kernel.org>
> > > > Sent: Thursday, August 04, 2005 4:56 PM
> > > > Subject: Re: RAID5 question.
> > > >
> > > >
> > > > > And notice you can apply different readahead to:
> > > > > The raw devices (/dev/sda)
> > > > > The md device (/dev/mdX)
> > > > > Any lvm device (/dev/lvm_name/lvm_device)
> > > > >
> > > > > David
> > > > >
> > > > > Raz Ben Jehuda wrote:
> > > > >
> > > > > >read the blockdev man page
> > > > > >
> > > > > >On Thu, 2005-08-04 at 16:06 +0200, djani22@dynamicweb.hu wrote:
> > > > > >
> > > > > >
> > > > > >>Hi list, Neil!
> > > > > >>
> > > > > >>I have a little question because I'v got some performance
problem...
> > > > > >>Is the RAID5 do any type of headahead with the default config?
> > > > > >>It is possible to disable the readahead? (if it is.)
> > > > > >>Or just the io_sched do that on the disks?
> > > > > >>
> > > > > >>How can I disable the whole headahead on top of the RAID5 array?
> > > > > >>
> > > > > >>The RAID5 can do multiple small (<4kb) reads of disks for the
> > > > multithreaded
> > > > > >>read requests?
> > > > > >>(chunk size is 32k)
> > > > > >>
> > > > > >>Thanks for helping!
> > > > > >>
> > > > > >>Janos
> > > > > >>
> > > > > >>-
> > > > > >>To unsubscribe from this list: send the line "unsubscribe
> > linux-raid" in
> > > > > >>the body of a message to majordomo@vger.kernel.org
> > > > > >>More majordomo info at
http://vger.kernel.org/majordomo-info.html
> > > > > >>
> > > > > >>
> > > > >
> > > > >
> > > > > --
> > > > >
> > > > > -
> > > > > To unsubscribe from this list: send the line "unsubscribe
linux-raid"
> > in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > >
> > > > -
> > > > To unsubscribe from this list: send the line "unsubscribe
linux-raid" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > Raz
> > > Long live the penguin
> > >
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> Raz
> Long live the penguin
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

