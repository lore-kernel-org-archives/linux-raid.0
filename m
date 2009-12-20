From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Typical RAID5 transfer speeds
Date: Sun, 20 Dec 2009 02:55:16 -0700
Message-ID: <200912200255.16513.tfjellstrom@shaw.ca>
References: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com> <4B2D4731.3090702@gmail.com> <4877c76c0912192021s2c3da63au57f5dcb0391b3eb3@mail.gmail.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0912192021s2c3da63au57f5dcb0391b3eb3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Roger Heflin <rogerheflin@gmail.com>, Matt Tehonica <matt.tehonica@mac.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat December 19 2009, Michael Evans wrote:
> On Sat, Dec 19, 2009 at 1:35 PM, Roger Heflin <rogerheflin@gmail.com> 
wrote:
> > Matt Tehonica wrote:
> >> I have a 4 disk RAID5 using a 2048K chunk size and using XFS
> >> filesystem. Typical file size is about 2GB-5GB. I usually get around
> >> 50MB/sec transfer speed when writting files to the array. Is this
> >> typcial or is it below normal?  A friend has a 20 disk RAID6 using the
> >> same filesystem and chunk size and gets around 150MB/sec. Any input on
> >> this??
> >>
> >> Thanks,
> >> Matt
> >
> > Speed depends on how the disks are connected to the system, and how
> > many disks there are per connection, and what kind of disks they are.
> >
> > If your friend had a 20 disk raid6 on one 4port sata pci-32bit/33mhz
> > card with port multipliers his total throughput would be <110mb/second
> > reads or writes, if your friend had 20 disks on 10+ port pcie-x16 cards
> > his total possible speed would be much much higher, reads would be
> > expected to be 18x(rawdiskrate) if the machine could handle it.
> >
> > Also newer disks are faster than older disks.
> >
> > 1.5tb disks read/write at 125-130+ MB/second on a fast port.
> > 1.5tb disks read/write at 75-80 MB/second on a PCI-32bit/33mhz port.
> > 500gb disks read/write at 75-80 MB/second on a PCI-32bit/33mhz port.
> > 250gb disks read/write at 50-55 MB/second on a fast port.
> >
> > And those PCI-32bit/33mhz ports are with only a single disk, put more
> > than one on there, and the io rates drop...so 2 disk on pci-32bit/33mhz
> > (old PCI) port will have <50MB/second each no matter how fast the disk
> > is, put 3 on there and each disk is down to 33mhz, 4 25MB/second or
> > less.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Speaking of 16x 16 port cards, why is it that it's so difficult to
> find an 8 or 16 port 4 or 8/16x pcie adapter?  A good 1xpci-e to 2x
> SATA costs like 25 to 50 USD.  Given the reduction in duplicate
> components, it should not be hard to make a card with 8 ports for 100
> USD or less right?  I don't even want any intelligence, just normal
> disk to PCI-E lane connectin would be fine.

While the driver support isn't "perfect"*, I have an AOC-SASLP-MV8, a 2 port 
SAS 4x PCI-e card. (with SAS->SATA converters, its an 8 port SATA card)

When I was running some tests on individual drives, and watching iostat, I 
saw over 500MB/s combined throughput, and that was with only 5 drives. 
Theoretically it should be capable of 1GB/s given its a x4 card. 
Theoretically.

At the very least, the card should be more than capable of providing enough 
bandwidth for all 8 ports to be filled with regular mechanical hard drives 
(sans port expanders).

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


* by "perfect" I mean the current kernel drivers don't work at all once you 
try and build a md-raid array on it. The new version of the drivers appeared 
in linux-scsi earlier this month, and should only need minor adjustments, 
but a second series haven't appeared yet, not sure when they'll make it into 
the kernel at this point. I was really hoping for them to make it into 
2.6.32, but heck, at this rate they might not make it for 2.6.33.

Even with all the troubles, this card has saved me hundreds in not having to 
buy a hw raid card :D, or a more expensive multi port sata/sas card. So I'm 
happy.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
