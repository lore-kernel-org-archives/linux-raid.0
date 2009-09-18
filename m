From: John Bridges <john.bridges@gmail.com>
Subject: Re: recommended 4port SATA controller ?
Date: Thu, 17 Sep 2009 17:52:15 -0700
Message-ID: <fa3b69580909171752s66cc3af6o753297b7a6c30dff@mail.gmail.com>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at>
	 <fa3b69580909171437s1074d7daqc4df84580ac9a9c3@mail.gmail.com>
	 <200909171702.47552.tfjellstrom@shaw.ca>
	 <fa3b69580909171723s733c3851u58e03b7fbc7a3da7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa3b69580909171723s733c3851u58e03b7fbc7a3da7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 17, 2009 at 5:23 PM, John Bridges <john.bridges@gmail.com> wrote:
> On Thu, Sep 17, 2009 at 4:02 PM, Thomas Fjellstrom <tfjellstrom@shaw.ca> wrote:
>> On Thu September 17 2009, John Bridges wrote:
>>> I'm a fan of the SuperMicro AOC-SAT2-MV8, great card.
>>> http://www.supermicro.com/products/accessories/addon/AOC-SAT2-MV8.cfm
>>>
>>> It's an 8 port PCI-X card, works in both PCI and PCI-X slots.
>>>
>>> SATA2
>>>
>>> Drivers for Linux are stable, built in.
>>>
>>
>> Have you had any experience with the AOC-SASLP-MV8? I've got one and have been
>> having no end of issues with it under linux.
>>
>
> I currently use it on a OpenSUSE 11.1 26.27.29-0.1 Kernel.
>
> With OpenSUSE 10.3, sometimes not all drives would be detected at
> first power-up because they all took so long to spin up one at a time.
> But when I rebooted all drives were seen. Otherwise no major issues
> under OpenSUSE 10.3.
>

I should mention under OpenSUSE 10.3, the hot swap didn't work. But
that's something I normally avoid.

I have hot swapped a couple times under OpenSUSE 11.1, and it worked
although I still prefer to not do so since the device lettering
changes if a drive is added or removed from the "middle".
