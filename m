From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid10 vs raid5 - strange performance
Date: Thu, 27 Mar 2008 10:18:31 +0100
Message-ID: <20080327091831.GC8033@rap.rap.dk>
References: <bb145bd20803251433q1018703cva56ea20e9bedf3c6@mail.gmail.com> <20080325233649.GA632@rap.rap.dk> <bb145bd20803251837x7ef1fa9dk6191fcaea7b02144@mail.gmail.com> <20080326072416.GA8674@rap.rap.dk> <bb145bd20803261016t351e4b98rb8989cc6c849108f@mail.gmail.com> <20080326192935.GB18621@rap.rap.dk> <bb145bd20803261811t6d836064g67d971a075075018@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bb145bd20803261811t6d836064g67d971a075075018@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Mar 27, 2008 at 02:11:43AM +0100, Christian Pernegger wrote:
> >  I have two on-board sata controller chips with each their version of HW
> >  RAID (NVIDIA and SIL)
> 
> I don't know of any nVIdia or Silicon Image onboard chips that can do
> raid in HW. Most likely it's BIOS-assisted software RAID. The 3ware
> should be the real article.

I am not sure of the difference. My understanding is that in both for
the NVIDIA and the SIL, and also for the 3ware, all logic is done in the
chip/controller.

I even think that the onboard chips have their own memory? How would it
else be possible for them to do RAID5 and RAID6 parity calculation?

> >  I think there is a tendency that SW raid like Linux kernel MD and Sun ZFS
> >  etc are more intelligent and can thus obtain better performance than HW
> >  RAID.
> 
> Performance is one thing, flexibility is another ...
> - end-to-end checksumming
> - ECC-on-read and / or bg scrubbing
> - arbitrary percentage of parity data (fs-level PAR2)
> - virtualized storage pools with actual backing store chosen based on
> usage hints
> - all configurable rule-based with file level granularity

Even for performance the SW raid tends to be more intelligent.
Viz your example that a 3are controller maxes out on its logic, 
that it is not the PCI bus bandwidth that limits the IO.
And 3ware is one of the most known HW raid vendors, and thus one of the
vendors that presumably have the greates knowledge on HW raids, and 
accordinly can produce the most intelligent controllers.

SW raid can do something like raid10,f2 which has much better optimized
IO than traditional RAID1+0, and also RAID5 has more intelligent 
writing algorithms than I would imagine that most HW controllers have,
as MD raid5 has a different strategy for writing sequential and writing
randomly. There are probably more examples of cleverer IO performance
tricks in Linux raid. 

The buttom line is that there are more people involved in making the
Linux SW raid, than there are for each of the closed drivers that HW
vendors make, and that the cumulated knowledge of the open source
community will produce better software because of much better personal
resources.

best regards
keld
