From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
	vg/lv - xfs
Date: Wed, 4 Aug 2010 11:13:17 +0200
Message-ID: <20100804091317.GA27779@isilmar-3.linta.de>
References: <20100804073546.GA7494@comet.dominikbrodowski.net> <20100804085039.GA11671@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100804085039.GA11671@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Christoph,

On Wed, Aug 04, 2010 at 04:50:39AM -0400, Christoph Hellwig wrote:
> On Wed, Aug 04, 2010 at 09:35:46AM +0200, Dominik Brodowski wrote:
> > How can I best track down the cause of the performance problem, 
> > a) without rebooting too often, and
> > b) without breaking up the setup specified above (production system)?
> 
> So did you just upgrade the system from an earlier kernel that did not
> show these problems?

No, 2.6.31 to 2.6.34 show similar behaviour.

>  Or did no one notice them before?

Well, there are some reports relating to XFS on MD or RAID, though I couldn't
find a resolution to the issues reported, e.g.

- http://kerneltrap.org/mailarchive/linux-raid/2009/10/12/6490333
- http://lkml.indiana.edu/hypermail/linux/kernel/1006.1/00099.html

However, I think we can rule out barriers, as XFS is mounted "nobarrier"
here.

Best,
	Dominik
