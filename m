From: Steven Dake <sdake@mvista.com>
Subject: Re: EIO AP-1680 ATA133 RAID PCI Controller
Date: Tue, 11 Feb 2003 10:16:53 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E493005.4030702@mvista.com>
References: <3E4329CE.5020706@netscape.net> <3E47E248.3080006@mvista.com> <3E48871A.3010709@netscape.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E48871A.3010709@netscape.net>
To: tk Voice <tkVoice@netscape.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't know the specifics of those cards, but if they include an i/o 
processor, they are a hardware RAID.

Keep in mind that unless you want to boot or use a RAID 5, or want to 
share your RAID volumes between different operating systems, there is 
little reason to purchase a hardware RAID card.  Software RAID is quite 
sufficient for most needs and the host processor running at 2+ ghz is 
much better at RAID then a 60 mhz i960 IOP.  Keep in mind, though, that 
hardware RAID adaptors have built in xor accelerators which can do 
multiple xors in one instruction in hardware, allowing for much better 
xor performance then the intel or ppc processor can do.

Thanks
-steve

tk Voice wrote:

> Thanks for the reply.
>
> I thought that $19 delivered was too good to be true!!!
>
> Are HP and Promise cards ture "HARDWARE" cards with there own I/O 
> processor?
>
> Peter
>
>>
>
>
>
>

