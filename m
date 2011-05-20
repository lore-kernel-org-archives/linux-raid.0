From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: Software raid, booting and bios
Date: Fri, 20 May 2011 11:00:35 +0100
Message-ID: <4DD63BC3.3010009@gmail.com>
References: <9067914580344941270@unknownmsgid>	<ir58vs$9qp$1@dough.gmane.org> <20110520145623.749b4781@natsu> <ir5ci1$uc6$1@dough.gmane.org>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ir5ci1$uc6$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Paul van der Vlis <paul@vandervlis.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul,
Please can you get some digital camera shots (resize them, low res and 
compress them) of the bios screen (or screen grabs if it's via a LOM).  
I'm especially interested in knowing if in the device listing there are 
two or more hard disks in the first place (as if there is only one disk 
I'd not be surprised at getting only one set of options).

Can you ask you rack space vendor the specific question 'how do I set up 
a secondary boot device ?".

Simon

On 20/05/2011 10:33, Paul van der Vlis wrote:
> Op 20-05-11 10:56, Roman Mamedov schreef:
>> On Fri, 20 May 2011 10:33:00 +0200
>> Paul van der Vlis<paul@vandervlis.nl>  wrote:
>>
>>> You can select the "boot device priority" where you can choose about
>>> devices types (DVD, harddisk, USB, network) but you can choose only one
>>> SATA disk. Study it, and you will see I am right. I've asked it to my
>>> rackserver-vendor, they say: "that's always the case".
>> How about just not buying crappy hardware from this lying vendor anymore.
>> http://ompldr.org/vOHB6Zw/bios4.jpg<- this is present in majority of
>> motherboard BIOSes since forever.
> Interesting. From what brand server is this?
>
>>> But I think I have had systems in the past, what could do it. An
>>> interesting question is then: how well is it tested?  What when e.g. a
>>> disk boots, and then gives an I/O error? I am looking for a well-tested
>>> way to solve this, and I am willing to pay for it or choose another
>>> hardware vendor for it.
>> Yes, I think it is conceivable that if a disk fails in a 'bad' way, i.e. by
>> locking up on reads, or reading the first sector but not the next ones it can
>> prevent the system from booting even with this priority system. I don't know
>> if chances of that are high, considering that quite often disks fail by also
>> ceasing to be detectable in BIOS, in which case your boot-up would proceed
>> normally.
> The problem is about detected disks with a defect in the MBR.
>
> With regards,
> Paul van der Vlis.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
