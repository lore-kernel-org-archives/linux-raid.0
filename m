From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: USB-to-SATA and RAID
Date: Tue, 23 Jan 2018 20:46:49 +0000
Message-ID: <3b12354d-d8bb-9593-8bee-489574caf84f@youngman.org.uk>
References: <20180123201614.GI23784@otheros>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180123201614.GI23784@otheros>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/01/18 20:16, Linus Lüssing wrote:
> Hi,
> 
> By chance I found this statement in the Linux RAID Wiki:
> 
> "Do NOT use [USB devices] as part of your array. They have
>   a timeout/disconnect mechanism which interacts very
>   badly with the raid code." [0]

That was me that wrote that on the wiki. However, I'm just editing stuff 
so I don't actually have any experience of it.
> 
> Could someone elaborate further on this? Does "interacts very
> badly" mean that there will be potential data loss / data
> corruption? Or does "very badly" just mean short, temporary
> performance issues / lags upon a disk failure?
> 
The wiki also mentions the timeout problem. As far as I can make out - 
and bear in mind as I said above I don't have personal experience - it 
seems to me from what I've picked up that USB suffers this problem in 
spades.

In other words, what I *think* happens, from what I've picked up, is 
that the USB bus times out. And when the raid comes along to use the 
disk, the USB bus is no longer responding ... BOOM!

> Regards, Linus
> 
I hope that's helpful, and maybe people who know more will chime in, but 
that's it as I understand it.

Cheers,
Wol
