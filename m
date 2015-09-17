From: Christoph Hellwig <hch@lst.de>
Subject: Re: raid5-cache I/O path improvements V2
Date: Thu, 17 Sep 2015 03:53:26 +0200
Message-ID: <20150917015326.GA22865@lst.de>
References: <1442038638-6947-1-git-send-email-hch@lst.de> <D21C6812.74CB%shli@fb.com> <87a8so6t8f.fsf@notabene.neil.brown.name> <20150915215458.GA1943628@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150915215458.GA1943628@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@lst.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Tue, Sep 15, 2015 at 02:54:59PM -0700, Shaohua Li wrote:
> > I don't want a sysfs config if we can possibly avoid it.
> > 
> > Christoph's code sets FUA on every block written to the log, both data
> > and metadata.  Is that really what we want?
> > 
> > I don't know much of the hardware details, but wouldn't setting FUA and
> > FLUSH on the last block written be just as effective and possibly faster
> > (by giving more flexibility to lower layers)??
> 
> How is it different against without FUA, eg, doing a flush after several bios?

It's just a more complicated version of doing the same..
