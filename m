From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Fri, 19 Oct 2007 11:09:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
References: <18200.49267.763509.924873@stoffel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18200.49267.763509.924873@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 19 Oct 2007, John Stoffel wrote:

>
> So,
>
> Is it time to start thinking about deprecating the old 0.9, 1.0 and
> 1.1 formats to just standardize on the 1.2 format?  What are the
> issues surrounding this?
>
> It's certainly easy enough to change mdadm to default to the 1.2
> format and to require a --force switch to  allow use of the older
> formats.
>
> I keep seeing that we support these old formats, and it's never been
> clear to me why we have four different ones available?  Why can't we
> start defining the canonical format for Linux RAID metadata?
>
> Thanks,
> John
> john@stoffel.org
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I hope 00.90.03 is not deprecated, LILO cannot boot off of anything else!


Justin.
