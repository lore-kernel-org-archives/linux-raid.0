From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Question with --assume-clean
Date: Sat, 15 Jan 2011 04:53:46 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1101150453250.8724@p34.internal.lan>
References: <alpine.DEB.2.00.1101142049080.18350@p34.internal.lan> <20110115154805.6e1b1f5a@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110115154805.6e1b1f5a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sat, 15 Jan 2011, NeilBrown wrote:

> On Fri, 14 Jan 2011 20:49:52 -0500 (EST) Justin Piszcz
> <jpiszcz@lucidpixels.com> wrote:
>
>> Hi,
>>
>> If I use --assume-clean and then run a check, will this perform the
>> initialization when using a RAID-1/RAID-6?
>>
>
> No - check doesn't write anything.
>
> But if you use --assume-clean then run a 'repair', it will perform the
> initialisation that --assume-clean deliberately avoided.
>
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi Neil,

Will run a repair on each, thank you.

Justin.

