From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: advice to low cost hardware raid (with mdadm)
Date: Wed, 15 Sep 2010 18:56:29 -0500
Message-ID: <4C915D2D.10607@hardwarefreak.com>
References: <00c6ed0254381567aff38d7a95d200c5.squirrel@fuckaround.org>    <4C912F5D.5040305@hardwarefreak.com> <b6947b76728ca8c5d78d4d05fbd7894c.squirrel@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b6947b76728ca8c5d78d4d05fbd7894c.squirrel@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pol Hallen put forth on 9/15/2010 5:03 PM:
> First all: sorry for my english :-P
> 
>> With four SATA drives on a new mobo
>> with an AHCI chip you'd see over 400 MB/s, about 4 times that of the PCI
>> 6 drive solution.  You'd have one drive less worth of capacity.
> 
> 400Mb/s is because the integrated controller of mobo reach that speed?

And more.  4 x 7.2k RPM SATA drives will do ~400 MB/s.  The Intel H55
mobo chipset has 6 (integrated) SATA2 ports for a total of 1800 MB/s.

The limitation in your initial example is the standard (32 bit/33 MHz)
PCI bus, which can only do 132 MB/s, and all PCI slots in the system
share that bandwidth.  The more cards you add, the less bandwidth each
card gets.  In you example, your 3 PCI SATA cards would only have 44
MB/s each, or 22 MB/s per drive.  Each drive can do about 100 MB/s, so
you're strangling them to only 1/5th their potential.  If you ever had
to do a rebuild of a RAID5/6 array with 6 1TB drives, it would take
_days_ to complete.  Heck, the initial md array build would take days.

PCI Express x1 v1 cards can do 250 MB/s PER SLOT, x4 cards 1000 MB/s PER
SLOT, x8 cards 2000 MB/s PER SLOT, x16 cards 4000 MB/s.  If you already
have two PCI Express x1 slots on your current mobo, you should simply
get two of these cards and connect two dives to each, and build a RAID10
or RAID5.  This method produces no bottleneck as these cards can do 250
MB/s each, or 125 MB/s per drive:

http://www.sybausa.com/productInfo.php?iid=878

> So is it a raid hardware (no need mdadm)? 

For real hardware RAID you will need to spend minimum USD $300 or so on
a PCIe card with 128MB of RAM and a RAID chip.  Motherboards do NOT come
with real hardware RAID.  They come with FakeRAID, which you do NOT want
to use.  Use Linux mdraid instead.  For someone strictly mirroring a
drive on a workstation to protect against drive failure, fakeRAID may be
an ok solution.  Don't use it for anything else.

> What happen if the controller
> goes break?

For this to occur, the south bridge chip on your mobo will have failed.
 If it fails, your whole mobo has failed.  It can happen, but how often?
 Buy a decent quality mobo--Intel, SuperMicro, Asus, ECS, GigaByte,
Biostar, etc--and you don't have to worry about it.

>> additionally, in the event
>> of a disk failure, rebuilding a 6x1TB RAID5/6 array will take forever
>> and a day.
> 
> a nightmare...

Yes, indeed.  Again, if you use 3 regular PCI cards, it will take
_FOREVER_ to rebuild the array.  If you use a new mobo with SATA ports
or PCIe x1 cards, the rebuild will be much much faster.  Don't get me
wrong, rebuilding an mdraid array of 6x1TB disks will still take a
while, but it will take at least 5-6 times longer using regular PCI SATA
cards.

> very thanks for your reasoning.. I don't have enought experience about
> raid and friends!

You're very welcome.  Glad I was able to help a bit.

-- 
Stan
