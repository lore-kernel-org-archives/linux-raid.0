From: Shaohua Li <shli@fb.com>
Subject: Re: raid5-cache I/O path improvements V2
Date: Tue, 15 Sep 2015 14:54:59 -0700
Message-ID: <20150915215458.GA1943628@devbig084.prn1.facebook.com>
References: <1442038638-6947-1-git-send-email-hch@lst.de>
 <D21C6812.74CB%shli@fb.com>
 <87a8so6t8f.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87a8so6t8f.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Tue, Sep 15, 2015 at 09:23:44AM +0200, Neil Brown wrote:
> Shaohua Li <shli@fb.com> writes:
> 
> > On 9/11/15, 11:17 PM, "Christoph Hellwig" <hch@lst.de> wrote:
> >
> >>Hi Shaohua, hi Neil,
> >>
> >>this series contains a few updates to the raid5-cache feature.
> >>
> >>The first patch just ports it to the post-4.2 block layer.  As part of
> >>that
> >>I noticed that it currently doesn't handle I/O errors - fixes for that
> >>will
> >>follow.
> >>
> >>The second and third patch simplify the I/O unit state machine and reduce
> >>latency and memory usage for the I/O units.  The remainder are just a
> >>couple
> >>of cleanups in this area that I stumbled upon.
> >>
> >>Changes since V1:
> >> - only use REQ_FUA if supported natively by the log device
> >
> > Hi Christoph,
> >
> > I finally got some data with a Samsung SSD, which supports fua. Controller
> > is ahci.
> > Test is a simple fio with all full stripe write.
> >
> > libata.fua=0, throughput 247m/s
> > libata.fua=1, throughput 74m/s
> 
> Eek!  That's a big price to pay!
> 
> >
> > fua is significantly slower. I think we need a sysfs config to enable fua.
> 
> I don't want a sysfs config if we can possibly avoid it.
> 
> Christoph's code sets FUA on every block written to the log, both data
> and metadata.  Is that really what we want?
> 
> I don't know much of the hardware details, but wouldn't setting FUA and
> FLUSH on the last block written be just as effective and possibly faster
> (by giving more flexibility to lower layers)??

How is it different against without FUA, eg, doing a flush after several bios?

Thanks,
Shaohua
