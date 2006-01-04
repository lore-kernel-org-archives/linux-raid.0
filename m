From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: Linux RAID Enterprise-Level Capabilities and If It Supports
	Raid Level Migration and Online Capacity Expansion
Date: Tue, 03 Jan 2006 17:39:32 -0800
Message-ID: <1136338773.7284.35.camel@seki.nac.uci.edu>
References: <200512221707.jBMH7PCS028943@cichlid.com>
	 <17323.2382.350576.347316@smtp.charter.net>
	 <Pine.LNX.4.58.0512222359390.13179@lajli.gau.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0512222359390.13179@lajli.gau.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Lajber Zoltan <lajbi@lajli.gau.hu>
Cc: John Stoffel <john@stoffel.org>, Andrew Burgess <aab@cichlid.com>, linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


There are those who believe that if you have a production system with
xfs, that you should always have a UPS, because xfs journals aren't as
thorough as the journals of some other filesystems, including ext3.

On Fri, 2005-12-23 at 00:02 +0100, Lajber Zoltan wrote:
> On Thu, 22 Dec 2005, John Stoffel wrote:
> 
> > I've been tempted by XFS at times, but I worry, esp since alot of
> > other people who are core developers don't care for XFS as much.  But
> > maybe I'll move that way for my next system.
> 
> We use xfs since 2.6.x in production. Typical config for us:
> / in raid1, ext3
> swap in raid1
> lvm2 for the remaining with XFS above it.
> 
> The lvm2 array raid1 or raid5. If raid1, the / and swap have hot spare
> partitions.
> 
> The main reason for this is that you can't have boot block in XFS.
> 
> Bye,
> -=Lajbi=----------------------------------------------------------------
>  LAJBER Zoltan               Szent Istvan Egyetem,  Informatika Hivatal
>  Most of the time, if you think you are in trouble, crank that throttle!
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

