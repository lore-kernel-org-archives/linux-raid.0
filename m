From: Raz Ben Jehuda <razb@bitband.com>
Subject: Re: RAID5 question.
Date: Thu, 04 Aug 2005 18:56:58 +0300
Message-ID: <1123171018.9269.1.camel@localhost.localdomain>
References: <17137.43778.476908.961140@cse.unsw.edu.au>
	 <01f001c598fd$c59a51a0$0400a8c0@LocalHost>
	 <1123164866.8854.0.camel@localhost.localdomain>
	 <42F22C8F.4000407@dgreaves.com>  <025301c5990b$8b456cc0$0400a8c0@LocalHost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <025301c5990b$8b456cc0$0400a8c0@LocalHost>
Sender: linux-raid-owner@vger.kernel.org
To: djani22@dynamicweb.hu
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

take a look at /proc/sys/dev/raid/speed_limit_max . it is kilobytes if i
recall correctly.

On Thu, 2005-08-04 at 17:45 +0200, djani22@dynamicweb.hu wrote:
> Thanks a lot for you, and Raz!
> 
> The raw devices readahead I already set with the hdparm, and
> /sys/block/*/queue/read_ahead_kb, but the md device is only changeable with
> blockdev. :-)
> I dont use lvm, because it is too slow for me....
> 
> But unfortunately the problem is still here for me. :(
> I continue searching the bottleneck...
> 
> Thanks!
> 
> Janos
> 
> ----- Original Message -----
> From: "David Greaves" <david@dgreaves.com>
> To: "Raz Ben Jehuda" <razb@bitband.com>
> Cc: <djani22@dynamicweb.hu>; <linux-raid@vger.kernel.org>
> Sent: Thursday, August 04, 2005 4:56 PM
> Subject: Re: RAID5 question.
> 
> 
> > And notice you can apply different readahead to:
> > The raw devices (/dev/sda)
> > The md device (/dev/mdX)
> > Any lvm device (/dev/lvm_name/lvm_device)
> >
> > David
> >
> > Raz Ben Jehuda wrote:
> >
> > >read the blockdev man page
> > >
> > >On Thu, 2005-08-04 at 16:06 +0200, djani22@dynamicweb.hu wrote:
> > >
> > >
> > >>Hi list, Neil!
> > >>
> > >>I have a little question because I'v got some performance problem...
> > >>Is the RAID5 do any type of headahead with the default config?
> > >>It is possible to disable the readahead? (if it is.)
> > >>Or just the io_sched do that on the disks?
> > >>
> > >>How can I disable the whole headahead on top of the RAID5 array?
> > >>
> > >>The RAID5 can do multiple small (<4kb) reads of disks for the
> multithreaded
> > >>read requests?
> > >>(chunk size is 32k)
> > >>
> > >>Thanks for helping!
> > >>
> > >>Janos
> > >>
> > >>-
> > >>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > >>the body of a message to majordomo@vger.kernel.org
> > >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >>
> > >>
> >
> >
> > --
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Raz
Long live the penguin

