From: GarBoge <garboge@shaw.ca>
Subject: Re: filesystem on mdadm raid from unpartioned block devices
Date: Fri, 14 Jan 2011 08:44:26 -0700
Message-ID: <1295019866.3788.2.camel@TRAVLOR>
References: <1294871497.16201.9.camel@TRAVLOR>
	 <20110113130044.3784907c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113130044.3784907c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the quick reply. I thank you for the great mdadm software.

Ashley


On Thu, 2011-01-13 at 13:00 +1100, NeilBrown wrote:
> On Wed, 12 Jan 2011 15:31:37 -0700 GarBoge <garboge@shaw.ca> wrote:
> 
> > A quick question that I haven't been able to find and answer for.
> > 
> > I have been using whole block devices (whole unpartitioned hard drives)
> > in various raid 1 and 5 setups using mdadm 3.1.4 with pretty mundane
> > options (default options such as striping and but using metadata 1.2).
> > Typically I use mkfs.ext4 with no options (default) to install the
> > filesystem.
> > 
> > Is there an issue with alignment on the newer 4096-byte drives. If so
> > what would be the proper approach?
> 
> No, no issue.
> 
> NeilBrown
> 
> 
> > 
> > I thank you for your time.
> > 
> > Ashley
> 


