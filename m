From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Change Stripe size?
Date: Mon, 31 Dec 2007 12:02:14 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712311201420.23402@p34.internal.lan>
References: <29a863790712310900o7c585e3bncfaf8d7bbc589998@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29a863790712310900o7c585e3bncfaf8d7bbc589998@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Cormier <gcormier@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 31 Dec 2007, Greg Cormier wrote:

> So I've been slowly expanding my knowledge of mdadm/linux raid.
>
> I've got a 1 terabyte array which stores mostly large media files, and
> from my reading, increasing the stripe size should really help my
> performance
>
> Is there any way to do this to an existing array, or will I need to
> backup the array and re-create it with a larger stripe size?
>
>
> Thanks and happy new year!
> Greg
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Backup the array and re-create it is currently the only way with sw 
raid AFAIK..

Justin.
