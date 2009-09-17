From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: recommended 4port SATA controller ?
Date: Thu, 17 Sep 2009 23:35:17 +0000
Message-ID: <73e903670909171635r4e60cb7cj548ae6ad8b152e3e@mail.gmail.com>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at>
	 <fa3b69580909171437s1074d7daqc4df84580ac9a9c3@mail.gmail.com>
	 <200909171702.47552.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200909171702.47552.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 17, 2009 at 11:02 PM, Thomas Fjellstrom <tfjellstrom@shaw.ca> wrote:
> On Thu September 17 2009, John Bridges wrote:
>> I'm a fan of the SuperMicro AOC-SAT2-MV8, great card.
>> http://www.supermicro.com/products/accessories/addon/AOC-SAT2-MV8.cfm
>>
>> It's an 8 port PCI-X card, works in both PCI and PCI-X slots.
>>
>> SATA2
>>
>> Drivers for Linux are stable, built in.
>>
>
> Have you had any experience with the AOC-SASLP-MV8? I've got one and have been
> having no end of issues with it under linux.
>
> --
> Thomas Fjellstrom
> tfjellstrom@shaw.ca
> --

I have,

or rather, I've tried to get an AOC-SASLP-MV8 card going. I think I
can safely say that at least Linux kernel 2.6.31 is a requirement. The
card was basically useless with everything up to 2.6.30, then I tried
2.6.31-rc5 on a whim and it kicked in. Built-in driver support, that
is. However it wasn't stable, it dropped disks when syncing a large
array. I've been meaning to test on 2.6.31 final, and am pretty
optimistic.

-- Kristleifur
