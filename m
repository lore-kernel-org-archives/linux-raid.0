From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: Max. md array size under 32-bit i368 ...
Date: Wed, 24 May 2006 12:55:25 -0400
Message-ID: <1148489725.26093.93.camel@localhost.localdomain>
References: <200605221746.38122.Dexter.Filmore@gmx.de>
	 <17522.17186.715844.748238@cse.unsw.edu.au>
	 <Pine.LNX.4.56.0605240913410.16780@lion.drogon.net>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0605240913410.16780@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2006-05-24 at 09:21 +0100, Gordon Henderson wrote:
> I know this has come up before, but a few quick googles hasn't answered my
> questions - I'm after the max. array size that can be created under
> bog-standard 32-bit intel Linux, and any issues re. partitioning.
> 
> I'm aiming to create a raid-6 over 12 x 500GB drives - am I going to
> have any problems?

afraid not. it is like (12-2) * 500 > 2TB.


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

