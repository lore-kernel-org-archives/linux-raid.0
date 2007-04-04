From: Just Marc <marc@corky.net>
Subject: Re: md126-7
Date: Wed, 04 Apr 2007 13:17:14 +0100
Message-ID: <4613974A.1050503@corky.net>
References: <46127910.9070006@corky.net> <17938.50144.495779.735588@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17938.50144.495779.735588@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,
> Maybe if you tell us what commands you ran, we could explain what you
> did?
> Maybe you did
>
>    mdadm -C /dev/bigdev -amd -l6 -n5 /dev/sd[a-e]
>
> As the name "bigdev" doesn't look like "md%d", it will just choose an
> unused number up around 127.
>
>   
You were absolutely right, thank you.  I was simply missing the device 
name when creating the array, something I usually do specify :)

It is a bit odd though that it picks an unused number that high, why 
doesn't it start from 0?

Thanks,
Marc

