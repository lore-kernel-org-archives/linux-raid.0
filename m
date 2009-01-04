From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: southbridge/sata controller performance?
Date: Sun, 4 Jan 2009 16:34:40 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901041632440.20628@p34.internal.lan>
References: <20090103193429.GA17462@sewage.raw-sewage.fake> <495FC67A.2030201@gmail.com> <alpine.DEB.1.10.0901040451520.18797@p34.internal.lan> <20090104194023.GB10174@sewage.raw-sewage.fake> <496123ED.5050809@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496123ED.5050809@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Matt Garman <matthew.garman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 4 Jan 2009, Roger Heflin wrote:

> Matt Garman wrote:
>
>> 
>> Are you talking about using additional SATA controllers (i.e. via
>> add-on cards)?  Or simply talking about the interconnect between the
>> southbridge and the northbridge?
>> 
>
> Don't count on it, it depends on the specific setup of the MB.
>
>> I think you're talking about the former, i.e. the SATA controller
>> integrated in the southbridge generally ought to be fine, but if you
>> start adding additional controllers that hang off the south bridge,
>> their could be competition for bandwidth to the northbridge...
>> right?  (And wouldn't the nvidia chips have an edge here, since they
>> have everything combined into one chip?)
>
> Again, it depends on how much bandwidth was allocated internally in the chip 
> just because it is one chip does not mean that anyone actually allocated 
> enough resources to the given part of the chip, or even has enough feed to 
> the chip to support them all.   The Seagate 1.5's will stream quite a bit 
> higher numbers than previous disks, so if one had several of them they could 
> overload the allocated bandwidth.   Things build-into a given MB aren't 
> always connected at full speed often some of them are actually pci bus parts 
> and suffer from slow access, I would expect there to be similar tradeoffs 
> even in single chip cases.
Yup that is why you need to check the schematic for the motherboard before
you purchase as to which PCI-e are "shared" vs. "switched" vs. dedicated

>
>> 
>> Makes intuitive sense anyway; but in my case I'm really just curious
>> about the SATA controller integrated into the southbridge; not
>> concerned with additional SATA controllers.
>> 
>
> The build-in intel ich series controllers vary from version to version on 
> exactly how fast that they are in this test, the newer ones are faster than 
> the older ones.
Agree, the Northbridge <-> CPU generally increases in speed each new chipset,
965 -> X38 -> X48 etc..

>
>> 
>> Is the "parallel dd test" valid if I do a raw read off the device,
>> e.g. "dd if=/dev/sda of=/dev/null"?  All my drives are already in an
>> md array, so I can't access them individually at the filesystem
>> level.
>> 
>> Thanks for the feedback and info!
>> 
>> Matt


