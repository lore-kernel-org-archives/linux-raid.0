From: Christoph Hellwig <hch@infradead.org>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
 vg/lv - xfs
Date: Wed, 4 Aug 2010 05:21:22 -0400
Message-ID: <20100804092122.GA2998@infradead.org>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
 <20100804085039.GA11671@infradead.org>
 <20100804091317.GA27779@isilmar-3.linta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100804091317.GA27779@isilmar-3.linta.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>, Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 04, 2010 at 11:13:17AM +0200, Dominik Brodowski wrote:
> > show these problems?
> 
> No, 2.6.31 to 2.6.34 show similar behaviour.

Ok, so it's been around for a while.  Can you test the write speed of
each individual device layer by doing a large read from it, using:

	dd if=<device> of=/dev/null bs=8k iflag=direct

where device starts with the /dev/sda* device, and goes up to the MD
device, the dm-crypt device and the LV.  And yes, it's safe to read
from the device while it's otherwise mounted/used.

