From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID5 how chage chunck size from 64 to 128, 256 ? is it possible
 ?
Date: Sat, 9 Feb 2008 04:14:51 -0500 (EST)
Message-ID: <alpine.DEB.1.00.0802090414310.27612@p34.internal.lan>
References: <1498963728.20080209074300@j8.com.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1498963728.20080209074300@j8.com.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas-Sokov <andre.s@j8.com.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When you reate the array its --chunk or -c -- I found 256 KiB to 1024 KiB 
to be optimal.

Justin.

On Sat, 9 Feb 2008, Andreas-Sokov wrote:

> Hi linux-raid.
>
> RAID5 how chage chunck size from 64 to 128, 256 ?
> is it possible ?
> Somebody did this ?
>
> --
> Best regards,
> Andreas-Sokov
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
