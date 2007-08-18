From: "Tomas France" <tomfra@centrum.cz>
Subject: Re: SWAP file on a RAID-10 array possible?
Date: Sat, 18 Aug 2007 10:52:56 +0200
Message-ID: <00a001c7e175$315c3c20$332317ac@Cortex>
References: <c70ff3ad0708070116k20605787pf897f9eccc93cd65@mail.gmail.com><5b170a7d0708070126t52cb4be5x4549b22bac643450@mail.gmail.com><c70ff3ad0708070302g1d23f4c8qd53c230d4118fd51@mail.gmail.com><18104.18410.623573.929770@notabene.brown><c70ff3ad0708070332n33296a9cp719a6e1b8860ec4b@mail.gmail.com><c70ff3ad0708070346u4b538be9j6d1b5cf83f535de6@mail.gmail.com><18104.21737.341407.654022@notabene.brown><c70ff3ad0708070431v3ba47ab0j533197d92aea884c@mail.gmail.com> <18104.23111.369229.891505@notabene.brown> <02a201c7df1b$07dec720$332317ac@Cortex> <46C2D101.8050205@dgreaves.com> <02db01c7df27$04321c60$332317ac@Cortex> <46C37342.9080509@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This wouldn't be probably the best solution in my situation. The computer we
are talking about will be quad-core web server with 8GB RAM and initially
2x500GB SATA HDDs setup in a RAID-1 array. When it begins running low on
space or more HDDs performance is needed, I plan to convert the RAID-1 to
RAID-10 by adding 2-4 more hard disks (I've found some info on how to do
this so hopefully it will work).

If I should follow the commonly accepted strategy saying that the swap space
should be 2X+ the amount of RAM, that means 16GB. If I add 4 more HDDs in
RAID-1 pairs later, then I would end up with 3 swap partitions on RAID-1
taking 96GB (6*16GB) of space on the harddrives which would be a
considerable waste of space.

Sure, when adding the more hard disks I could probably create a smaller swap
partition on each of them but that would be yet another complication. Using
a swap file initally on the RAID-1 array and then on the RAID-10 array
sounds like a much simpler solution to me as it  will allow me to change the
size of the swap space more flexibly.

Tomas



----- Original Message ----- 
From: "Michael Tokarev" <mjt@tls.msk.ru>
To: "Tomas France" <tomfra@centrum.cz>
Cc: <linux-raid@vger.kernel.org>
Sent: Wednesday, August 15, 2007 11:42 PM
Subject: Re: SWAP file on a RAID-10 array possible?


> Tomas France wrote:
>> Thanks for the answer, David!
>>
>> I kind of think RAID-10 is a very good choice for a swap file. For now I
>> will need to setup the swap file on a simple RAID-1 array anyway, I just
>> need to be prepared when it's time to add more disks and transform the
>> whole thing into RAID-10... which will be big fun anyway, for sure ;)
>
> By the way, you don't really need raid10 for swap.  Built-in linux
> swap code can utilize multiple swap areas just fine - mkswap + swapon
> on multiple devices/files.  This is essentially a raid0.  For raid10,
> one thing needed is the mirroring, with is provided by raid1.  So
> when you've two drives, use single partition on both to form a raid1
> array for swap space.  If you've 4 drives, create 2 raid1 arrays and
> specify them both as swap space, giving them appropriate priority
> (prio=xxx in swap line in fstab).  With 6 drives, have 3 raid1 arrays
> and so on...  This way, the whole thing is much simpler and more
> manageable.
>
> /mjt
>

