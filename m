From: Maarten <maarten@ultratux.net>
Subject: Re: Raid6 array crashed-- 4-disk failure...(?)
Date: Mon, 15 Sep 2008 19:14:57 +0200
Message-ID: <48CE9811.60307@ultratux.net>
References: <48CE250C.8000603@ultratux.net> <20080915125951.GA17966@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080915125951.GA17966@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Noll wrote:
> On 11:04, Maarten wrote:
>> This weekend I promoted my new 6-disk raid6 array to production use and 
>> was busy copying data to it overnight. The next morning the machine had 
>> crashed, and the array is down with an (apparent?) 4-disk failure, as 
>> witnessed by this info:
> 
> Believe it or not: The same thing (6-disk raid6, 4 disks failed)
> happened also to me during this weekend.

Hehe. It doesn't get more scary than this.... ;-)

>> 4) If it was only a one-drive failure, why did it kill the array ?
> 
> As others have already pointed out, this was not a one-drive
> failure. In my case, the two SATA disks which are still functional
> are connected to a 3ware controller while the four failed disks use
> the onboard SATA controller [1]. Therefore I'm confident that this
> is just a problem with the onboard SATA chip and that the array can
> be assembled again after a reboot. I'll have to wait until the end
> of the week to reboot that machine though.
> 
> Are you also using an Intel-based SATA chip (please send the output
> of lspci -v)?  Also, which kernel version are you using?

No, my chipset is a VIA one. Because the VIA SATA chips/drivers are 
terrible, I use only SATA PCI cards with Sil chipsets.  Believe it or 
not I have good/excellent experiences with these. The driver is quite 
stable, better than everything else I tried.

apoc log # lspci
00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP] 
Host Bridge (rev 80)
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
00:07.0 RAID bus controller: Silicon Image, Inc. SiI 3114 
[SATALink/SATARaid] Serial ATA Controller (rev 02)
00:08.0 RAID bus controller: Silicon Image, Inc. SiI 3114 
[SATALink/SATARaid] Serial ATA Controller (rev 02)
00:09.0 RAID bus controller: Silicon Image, Inc. SiI 3114 
[SATALink/SATARaid] Serial ATA Controller (rev 02)
00:0a.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial 
ATA Controller (rev 02)
00:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 
Gigabit Ethernet (rev 10)
00:0f.0 IDE interface: VIA Technologies, Inc. 
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge 
[KT600/K8T800/K8T890 South]
01:00.0 VGA compatible controller: ATI Technologies Inc Rage XL AGP 2X 
(rev 65)

Linux apoc 2.6.23-gentoo-r3 #2 Fri Apr 25 11:09:37 CEST 2008 i686 AMD 
Sempron(tm) 2200+ AuthenticAMD GNU/Linux


>> 5) Any insight as to how this happened / can be prevented in future ?
> 
> Don't use cheap hardware (Fast, cheap, good. Pick two) ;)

How true. In this case I think(or hope) I went for "cheap, good"... 
Sixteen disks on 4 PCI slots (but still a single PCI bus!) is far from 
fast indeed. ;-) I get a rebuild speed of 20436K/sec on a 5-disk raid5 
array (SATA 250 GB disks), which is not terrible, but not fast either.

I'm considering a 8/12/16 port Areca controller but a few practicalities 
hold me back: the price, and the fact I would need a PCI-X slot unless I 
want to kill performance by a factor of 10. Also, the fact that I then 
cannot use software raid anymore tends to scare me a little: You never 
know how firmware reacts in the more 'interesting' circumstances, and 
you lose control over it...

Maarten

> Andre
> 
> [1] 00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA
> Storage Controller AHCI (rev 09)

