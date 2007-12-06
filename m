From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Reading takes 100% precedence over writes for mdadm+raid5?
Date: Thu, 6 Dec 2007 04:27:09 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712060426440.6948@p34.internal.lan>
References: <Pine.LNX.4.64.0712021807260.10289@p34.internal.lan>
 <18259.15708.870492.17273@notabene.brown>  <Pine.LNX.4.64.0712021821290.13428@p34.internal.lan>
  <cccedfc60712051727u4164b488o820509087f46cbcd@mail.gmail.com>
 <Pine.LNX.4.64.0712060406170.5626@p34.internal.lan>
 <72dbd3150712060126r26031b9aqbec25f92a084114e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150712060126r26031b9aqbec25f92a084114e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Jon Nelson <jnelson@jamponi.net>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 6 Dec 2007, David Rees wrote:

> On Dec 6, 2007 1:06 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> On Wed, 5 Dec 2007, Jon Nelson wrote:
>>
>>> I saw something really similar while moving some very large (300MB to
>>> 4GB) files.
>>> I was really surprised to see actual disk I/O (as measured by dstat)
>>> be really horrible.
>>
>> Any work-arounds, or just don't perform heavy reads the same time as
>> writes?
>
> What kernel are you using? (Did I miss it in your OP?)
>
> The per-device write throttling in 2.6.24 should help significantly,
> have you tried the latest -rc and compared to your current kernel?
>
> -Dave
>

2.6.23.9-- thanks will try out the latest -rc or wait for 2.6.24!

Justin.
