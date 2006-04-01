From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Recommendations for supported 4-port SATA PCI card ?
Date: Sat, 01 Apr 2006 17:38:02 +0400
Message-ID: <442E823A.2000400@wasp.net.au>
References: <442BFB2B.6090903@stams.strath.ac.uk> <442D22CD.3010602@nighthawkrad.net> <442DC92E.8080003@wasp.net.au> <442E6929.9090802@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442E6929.9090802@nighthawkrad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Smith <csmith@nighthawkrad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christopher Smith wrote:
> Brad Campbell wrote:
>> I've been running 3 together in one box for about 18 months, and four 
>> in another for a year now... the on board BIOS will only pickup 8 
>> drives, but they work just fine under Linux and recognise all 
>> connected drives.
> 
> What distro and kernel ?

Err.. well, I started with 2.4 originally and I've run 2.6.5, 2.6.9, 2.6.10-bk10, 2.6.15.1 and now 
2.6.16 on both boxes.. never an issue with multiple card support..

It's based on Debian mostly, but to be honest it's not important as the kernel is always self 
compiled as with mdadm..

> 
> I tried this about 2 - 3 months ago and had problems whenever more than 
> two cards were in my system, even if only a single drive was installed. 
>  I posted about it here (search for "multiple promise sata150 tx4 cards" 
> back in January).

I recall the thread.. don't think I replied then as I did not really have anything to say I guess.

> 
> I have no complaints about the performance (relatively speaking, of 
> course), but I've got the cards in a machine with multiple PCI-X busses, 
> so it's not really bottlenecked there.

Perhaps its related to that. All mine are on ASUS A7V600 motherboards with a single bog standard PCI 
bus. At one point early on I recall someone stating they were having all sorts of problems with 
those cards and a 66Mhz bus..

Are you running the latest BIOS in all the cards? Only ask as the 1st thing I did when mine arrived 
was to upgrade the BIOS.. not using it but I thought it might have some impact on the way they are 
set up on the PCI bus.

I have a mate who has another 3 in his box also.. but again he's on an ASUS A7V600 motherboard.

I'm looking to build another 15 drive box soon and I was thinking of perhaps a couple of 8 port 
Marvell cards, but then I might just stick with what I know and source some more of the same.

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
