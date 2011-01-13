From: NeilBrown <neilb@suse.de>
Subject: Re: filesystem on mdadm raid from unpartioned block devices
Date: Thu, 13 Jan 2011 13:00:44 +1100
Message-ID: <20110113130044.3784907c@notabene.brown>
References: <1294871497.16201.9.camel@TRAVLOR>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1294871497.16201.9.camel@TRAVLOR>
Sender: linux-raid-owner@vger.kernel.org
To: GarBoge <garboge@shaw.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 12 Jan 2011 15:31:37 -0700 GarBoge <garboge@shaw.ca> wrote:

> A quick question that I haven't been able to find and answer for.
> 
> I have been using whole block devices (whole unpartitioned hard drives)
> in various raid 1 and 5 setups using mdadm 3.1.4 with pretty mundane
> options (default options such as striping and but using metadata 1.2).
> Typically I use mkfs.ext4 with no options (default) to install the
> filesystem.
> 
> Is there an issue with alignment on the newer 4096-byte drives. If so
> what would be the proper approach?

No, no issue.

NeilBrown


> 
> I thank you for your time.
> 
> Ashley

