From: Chris Mason <chris.mason@oracle.com>
Subject: Re: direct-io regression [Was: How to track down abysmal
 performance ata - raid1 - crypto - vg/lv - xfs]
Date: Thu, 5 Aug 2010 11:39:43 -0400
Message-ID: <20100805153943.GO29846@think>
References: <20100805123649.GA18672@dhcp231-156.rdu.redhat.com>
 <20100805113240.GA29846@think>
 <20100805153519.GA7242@comet.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100805153519.GA7242@comet.dominikbrodowski.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>, josef@redhat.com, Valdis.Kletnieks@vt.edu, Michael Monnerie <michael.monnerie@is.it-management.at>, Christoph Hellwig <hch@infradead.or>
List-Id: linux-raid.ids

On Thu, Aug 05, 2010 at 05:35:19PM +0200, Dominik Brodowski wrote:
> Hey,
> 
> On Thu, Aug 05, 2010 at 07:32:40AM -0400, Chris Mason wrote:
> > But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
> > seems a little high.  
> 
> Well, that's what it does:
> 
> # $ dd if=/dev/mapper/vg0-home_crypt of=/dev/zero iflag=direct bs=8k count=131072 seek=131072
> # 131072+0 records in
> # 131072+0 records out
> # 1073741824 bytes (1.1 GB) copied, 62.0177 s, 17.3 MB/s

Can I ask you to do the test directly to the real honest to goodness
drive?   If it were an SSD I'd be less surprised, but then the extra
submits shouldn't hurt the ssd that much either.

Thanks for testing the patch, I'll send it in.

-chris
