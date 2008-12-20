From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Supermicro AOC-SAT2-MV8
Date: Sat, 20 Dec 2008 09:17:42 +0400
Message-ID: <494C7FF6.6050100@wasp.net.au>
References: <C571CD8F.BA37%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C571CD8F.BA37%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: Max Waterman <davidmaxwaterman@fastmail.co.uk>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Iain Rauch wrote:
>> OK, so it sounds like my suspicions were correct - I have PCI/PCIe.
>>
>> You say I would be better to use PCIe, but the card is PCI-X. Can I use
>> PCI-X in a PCIe slot?
> 
> No, but if you would like better performance (and can afford it), a PCIe
> card is the better option. Depending on your usage and requirements, PCI-X
> will be fine, but as mentioned it may not physically fit in your particular
> motherboard. You need to check what slots you do have as PCIe come in a
> variety of sizes also.

That is painfully true. I have a board with a pair of 16x and a pair of 1x slots.
It also has 2 PCI-X slots and I was about to purchase the board you mention in the subject line, but 
after a bit of digging I came up with these little beauties instead.

http://www.startech.com/item/PEXSATA24E-4-Port-PCI-Express-x4-SATA-II-Card.aspx

I'm using them in a server, so I used a PCI graphics card to free up both PCIe 16x slots and popped 
two of these in. They appear to be nicely supported and go like stink.

I also used a dual port SIL-3132 board in one of the PCIe 1x slots to fill out my 10 ports. It to is 
extremely well supported.

After I placed the order with Startech, I located identical boards under a "fujitech" branding 
(Cheap far-eastern supplier) which were/are *identical* in every respect excepting they only cost 
about $90 each. Cheap and reliable (I picked up a couple of extras as spares).

I was replacing 3 x Promise SATA150-TX cards (4 port) which are just flaky in multi-card 
configurations on anything other than an old PCI 33Mhz bus and I've been very happy with the results.

Sonnet also make a 4 port PCIe card using the same chip, but its almost twice the price and uses 
pretty much the same hardware.

These Marvell 7042 chips are great. Cheers Mark!!

You can use a PCI-X card in a PCI slot, but I believe you'll be disappointed with the results.

If you only need a couple of ports and have a PCIe 1x slot available, the SIL-3132 cards are 
available everywhere and are really pretty good.

Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
