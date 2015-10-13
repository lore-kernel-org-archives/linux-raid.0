From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] md: don't export log device
Date: Tue, 13 Oct 2015 05:07:19 -0700
Message-ID: <20151013120719.GA9734@infradead.org>
References: <cover.1443973492.git.shli@fb.com>
 <7aecea0895b46e28c2b8a876a83da10d7f30d7f1.1443973492.git.shli@fb.com>
 <87pp0q6s1i.fsf@notabene.neil.brown.name>
 <20151008031644.GA3063621@devbig084.prn1.facebook.com>
 <87bnca6lli.fsf@notabene.neil.brown.name>
 <20151008043121.GA3189627@devbig084.prn1.facebook.com>
 <8737xl7v5l.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8737xl7v5l.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Thu, Oct 08, 2015 at 05:04:54PM +1100, Neil Brown wrote:
> Having two disks with ->raid_disk==0 does seem a little weird, but we do
> already have that in some cases.
> When you have a hot-replace going, both the original and the replacement
> have the same ->raid_disk numbers.  They can be distinguished by the
> Replacement flag.
> I'm suggesting the same (sort of) for journals, and distinguish by the
> Journal flag.
> 
> I did quick audit and just found setup_conf, run() and md_update_sb().
> If you could do an audit to that would be good.  I'd be surprised if you
> find many more places where Journal needs to be tested with ->raid_disk.

Overloading positive numbers for the journal disk sounds like a bad idea
to me as it will cause a lot of confusion.  I'd rather assign specific
negative values to special roles outside the actual rate.  This will
require an initial audit, but give us nicely understandable rules later
on.
