From: Jeff Wiegley <jeffw@csun.edu>
Subject: Re: Why would a recreation cause a different number of blocks??
Date: Thu, 24 Apr 2014 22:02:05 -0700
Message-ID: <5359EC4D.7000308@csun.edu>
References: <20140424070548.445497dd@netstation> <20140424194832.2d0a867f@netstation> <CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com> <20140424203506.5fdee0d3@netstation> <CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail <53598F69.5070700@csun.edu> <alpine.DEB.2.02.1404250533040.19744@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1404250533040.19744@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'll look into this. I kind of thought about that sort
of thing and I went and installed ubuntu 12.04 which I
thought was what I started this all with but I might
have done it earlier than 12.04 and I might have used
gentoo.

are the mdadm defaults specific to mdadm version or
would ubuntu and gentoo have specified different
defaults in something like an /etc/defaults/ourmdadm.cfg?

If it's mdadm then could I just grab old copies of mdadm
sources and compile them one version after the other and
try each one?

Thanks,

- Jeff

On 4/24/2014 8:34 PM, Mikael Abrahamsson wrote:
> On Thu, 24 Apr 2014, Jeff Wiegley wrote:
>
>> Why did my block counts change? The disk partitions weren't touched
>> or changed at any point. Shouldn't I have gotten the same size?
>
> Defaults in mdadm has changed over time, so data offsets might be
> different. In order to get the exact same data offset you need to use the
> same mdadm version as was originally used, or at least know the values it
> used and use mdadm 3.3 that allows you to specify these data at creation
> time,
>
>> The created device isn't work. There is suppose to be luks encrypted
>> volume there but luksOpen reports there is no luks header. (and there
>> use to be). Would the odd change in size indicate total corruption?
>
> No, the change in size indicates that data offsets are not the same so
> your beginning of volume is now in the wrong place.
>

