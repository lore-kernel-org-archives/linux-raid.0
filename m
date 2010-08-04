From: Christoph Hellwig <hch@infradead.org>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
 vg/lv - xfs
Date: Wed, 4 Aug 2010 04:50:39 -0400
Message-ID: <20100804085039.GA11671@infradead.org>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100804073546.GA7494@comet.dominikbrodowski.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dominik Brodowski <linux@dominikbrodowski.net>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 04, 2010 at 09:35:46AM +0200, Dominik Brodowski wrote:
> How can I best track down the cause of the performance problem, 
> a) without rebooting too often, and
> b) without breaking up the setup specified above (production system)?

So did you just upgrade the system from an earlier kernel that did not
show these problems?  Or did no one notice them before?
