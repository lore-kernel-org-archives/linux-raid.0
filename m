From: Christoph Hellwig <hch@lst.de>
Subject: Re: raid5-cache I/O path improvements V2
Date: Wed, 30 Sep 2015 17:00:15 +0200
Message-ID: <20150930150015.GA26216@lst.de>
References: <1442038638-6947-1-git-send-email-hch@lst.de> <D21C6812.74CB%shli@fb.com> <87a8so6t8f.fsf@notabene.neil.brown.name> <20150915215458.GA1943628@devbig084.prn1.facebook.com> <20150928140127.GA30927@lst.de> <87vbaslb2v.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87vbaslb2v.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Shaohua Li <shli@fb.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Wed, Sep 30, 2015 at 03:39:52PM +1000, Neil Brown wrote:
> Christoph Hellwig <hch@lst.de> writes:
> 
> > So the summary is that for now you want me to resend with a patch
> > to opt into using FUA?
> 
> I'd like to avoid "opt in" if at all possible.
> Shoahua measured that using "FUA" for all writes to the journal
> hurt performance on at least one device.  Do you have a different device
> where it demonstrably helps?
> If there any chance of automatically detecting which is which?

I have a high end SAS SSD where it helps, but the real use case where
it makes a major difference are battery backed dimms (NV-DIMMS) or
other devices where we don't even need the FUA bit as they don't have
a cache at all.  The important part is to avoid the batching up for
the non-existant flush in that case.

So I could defintively default the code to on only for those, but not
even allowing a tunable for devices that have the FUA bit seems like
an odd restriction.
