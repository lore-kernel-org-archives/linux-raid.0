From: "Phantazm" <phantazm@phantazm.nu>
Subject: Re: Huge mdadm resync problem.
Date: Thu, 17 Feb 2005 15:57:12 +0100
Message-ID: <cv2b71$q83$1@sea.gmane.org>
References: <20050217145217.327494214a19146cf7@mail.kip.uni-heidelberg.de> <cv29q2$l2l$1@sea.gmane.org> <Pine.LNX.4.56.0502171435420.819@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It might be worht a try. I have 6 pci slots.  That i know of today my mobo 
shares irq on pci 5 and 2. looks like i cant get around that.

I have disabled apic on mobo too.
Going to see if i can get me 2 more ata133 cards then to see if i get more 
lucky :)

Thanx for your answers and suggestions.

"Gordon Henderson" <gordon@drogon.net> skrev i meddelandet 
news:Pine.LNX.4.56.0502171435420.819@lion.drogon.net...
> On Thu, 17 Feb 2005, Phantazm wrote:
>
>> I use master slave. Problem is that i cant break raid set couse if i do i
>> will loose over 1TB of data :/
>>
>> Goin to see if i can get more controller cards though.
>
> Do it. Use 4 2-port cards for your 8 drives and only one drive per cable.
> It is possible, and I've had it happen to me, that a hardware failure on a
> failing drive can cause loss of access to the 2nd drive on the same cable.
> Fortunately when it happened to me, the disks weren't in a RAID set and I
> didn't lose any data on the other drive, but if the disks were in a RAID
> set, then you'd have a 2-disk failure on your hands, and unless it was
> RAID-6, then you'd be shafted!
>
> I was about to suggest running with noapic, but you've already tried
> that... You might also want to see if the motherboard has a way to turn
> the APIC off too. I had that on one Athlon mobo, and running it all in PIC
> mode kept it going much better.
>
> Also experiment with PCI slot locations, although with 4 PCI cards, you
> might not have much luck, depending on your motherboard. Try to get each
> card on its own interrupt if at all possible. Some BIOSes can help fix
> this for you, some can't....
>
> Gordon
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



