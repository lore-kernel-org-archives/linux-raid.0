From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: Re: Supermicro AOC-SAT2-MV8
Date: Sat, 20 Dec 2008 00:07:05 +0200
Message-ID: <494C1B09.3000403@fastmail.co.uk>
References: <C571C6FB.BA32%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C571C6FB.BA32%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Iain Rauch wrote:
>> I'm looking into getting another drive and have noticed I've run out of
>> SATA ports (and EIDE, as it happens).
>>
>> So, I'm looking at a PCI card for SATA and went back to look at that
>> Supermicro AOC-SAT2-MV8 card - I've had my eye on it for a few years, or
>> perhaps it was a previous version of the same thing, I'm not sure.
>>
>> Anyway, I'm worried that it isn't the correct bus type for my computer.
>> I'm confused by the PCI-X and PCIe types, and I don't have access to my
>> computer over Christmas.
>>
>> My motherboard is some consumer level MSI board, and I just added an
>> nVidia graphics card on the same bus (it used one of the two longer slots).
>>
>> Could someone with better knowledge of such things hazzard a guess?
>>     
>
> I'm sure you will have PCI on your board, but it's unlikely that you have
> PCI-X. You can use the PCI-X card in a PCI slot, but the speed will be
> reduced.
> If you have PCIe slots (which is likely if the board is less than a couple
> of years old), you are better to use them as they are faster than PCI/PCI-X.
>   
OK, so it sounds like my suspicions were correct - I have PCI/PCIe.

You say I would be better to use PCIe, but the card is PCI-X. Can I use
PCI-X in a PCIe slot?

Max.
>
> Iain
>
>
>   

