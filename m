From: John Bridges <john.bridges@gmail.com>
Subject: Re: recommended 4port SATA controller ?
Date: Thu, 17 Sep 2009 17:23:18 -0700
Message-ID: <fa3b69580909171723s733c3851u58e03b7fbc7a3da7@mail.gmail.com>
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

On Thu, Sep 17, 2009 at 4:02 PM, Thomas Fjellstrom <tfjellstrom@shaw.ca> wrote:
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

I currently use it on a OpenSUSE 11.1 26.27.29-0.1 Kernel.

With OpenSUSE 10.3, sometimes not all drives would be detected at
first power-up because they all took so long to spin up one at a time.
But when I rebooted all drives were seen. Otherwise no major issues
under OpenSUSE 10.3.

Have not had those issues with OpenSUSE 11.1, works perfectly.

Have tested with a variety of 400GB, 750GB, 1TB and 1.5TB drives.

This is with a PCI-X supporting motherboard.

My only experience with the board in a PCI slot is with Win2003
Server, no issues.
