From: Neil Brown <neilb@suse.de>
Subject: Re: Potential mdadm 2.6.7 bug: Cannot grow linear arrays with superblock
 v1.0, 1.1, or 1.2
Date: Mon, 20 Oct 2008 12:15:07 +1100
Message-ID: <18683.56219.129104.439904@notabene.brown>
References: <8CAFC3107449F0E-C80-C20@mblk-d47.sysops.aol.com>
	<18677.25654.376918.24997@notabene.brown>
	<8CAFE6E1B94976D-C0-14F3@FWM-D03.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from thomas62186218@aol.com on Friday October 17
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 17, thomas62186218@aol.com wrote:
> Hi Neil,
> 
> Thank you for the reply and the patch. I patched 2.6.7 (had to tweak 
> the patch a little), but this patch seems to have done the trick. I can 
> now resize linear arrays of different sizes even with superblock 1.0.

Thanks for reporting back.

> 
> Was this patch already out there? Or is this a new one? If new, will 
> this be committed in?

This is in my git tree

http://neil.brown.name/git?p=mdadm;a=commitdiff;h=1c6cb603fa60d3425f4d4b76e721b485bb006fcb

and so will be in 2.6.8 and 3.0 whenever I release those.

NeilBrown
