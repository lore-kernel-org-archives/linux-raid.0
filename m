From: Neil Brown <neilb@suse.de>
Subject: Re: Max. md array size under 32-bit i368 ...
Date: Thu, 25 May 2006 14:54:15 +1000
Message-ID: <17525.14455.604933.928728@cse.unsw.edu.au>
References: <200605221746.38122.Dexter.Filmore@gmx.de>
	<17522.17186.715844.748238@cse.unsw.edu.au>
	<Pine.LNX.4.56.0605240913410.16780@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gordon Henderson on Wednesday May 24
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday May 24, gordon@drogon.net wrote:
> 
> I know this has come up before, but a few quick googles hasn't answered my
> questions - I'm after the max. array size that can be created under
> bog-standard 32-bit intel Linux, and any issues re. partitioning.
> 
> I'm aiming to create a raid-6 over 12 x 500GB drives - am I going to
> have any problems?

No, this should work providing your kernel is compiled with CONFIG_LBD.

NeilBrown

> 
> (I'm not parittioning the resulting md device, just the underlying sd
> devices and building a single md out of  sd[a-l]4 ...)
> 
> Cheers,
> 
> Gordon
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
