From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: System hangs on raid md recovery/resync - revisit
Date: Sat, 28 Feb 2009 04:08:44 -0500 (EST)
Message-ID: <alpine.DEB.2.00.0902280407520.17966@p34.internal.lan>
References: <da290bd50902271732m54a32ad6r5797f618f5af7d7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <da290bd50902271732m54a32ad6r5797f618f5af7d7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad <brad46526@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 28 Feb 2009, Brad wrote:

> Hi.  I'd like to revisit a problem I put to the mailing list on the
> 27th July 2008.
>
> My linux system hangs if I have a lengthy recovery of a raid-1
> device going on at the same time as any significant network
> traffic.  If I terminate my networking applications the re-sync
> succeeds; if I allow them to run then the re-sync will almost always
> hang the system.
>
> My PC is about 1.5 years old; it has a Gigabyte GA-P35-DS4 motherboard
> with an Intel Core 2 Quad Q6600 CPU.  The motherboard
> has an Intel ICH9R northbridge with 6 SATA 2 ports and a 'Gigabyte'
> (JMicron 20360/20363) southbridge with 2 SATA 2 ports.  I have two
> 500GB Western Digital SATA 2 internal disks, both on the ICH9R northbridge,
> as I used to get occasional SATA disconnects/errors if I had a disk under
> heavy load on the JMicron controller.  The two disks have 400GB
> partitions in a MD raid1 mirror.  I typically experience this problem when
> I plug in a third disk (also on the ICH9R controller) to synchronise as
> a backup procedure, but it also happens if I just have the two permanent
> disks synchronising between themselves.
>
> I'm running Linux  2.6.28.6.  The motherboard has a Realtek RTL8111/8168B
> gigabit ethernet controller which I have running in a 100Mbit full duplex
> link to my ADSL modem.  I'm using the kernel's standard r8169 driver for the
> network.
>
> If I have no significant network activity taking place (other than trivial
> traffic from named, ntpd and the like) then my md1 recoveries always
> succeed.  But if I have a program maxing out the connection to my ISP -
> about 160KB/sec down, 30KB/sec up - then the re-synchronisation will
> always end up hanging:
>
> o  disk I/O stops - the disk activity LED will stop flashing, iostat statistics
>    will drop to zero, 'cat /proc/mdstat' will show dwindling I/O speeds and
>    ever-increasing finish times (from 200 minutes to 30,000+ minutes!).
>
> o  any access to the filesystem I have mounted on top of the md1 device
>    hangs.
>
> o  access to OTHER filesystems is fine, and anything independent of the
>    hung filesystem works as normal.
>
> There are absolutely no errors reported by the system - nothing logged
> to the console and nothing logged via syslog (the /var/log filesystem
> is fully operational even while the recovering one is hung).
>
> Looking at /proc/interrupts I can see that the 'eth0' driver has an
> interrupt all to itself.
>
> I haven't had a single SATA disconnect error since I moved all my disks
> off the JMicron southbridge.  I can 'dd' each drive simultaneously with
> no errors and better than 70MB/sec throughput from each in parallel.
>
> Does anyone know of any condition which would cause the md1
> recovery process to silently hang like this?  Can I get some sort of
> debug/verbose log out of the raid software to work out why it's hanging?
>
> Has anyone ever experienced this sort of problem - md recovery
> 'sensitivity' to network traffic? - on this motherboard?

I have the same mobo:

Handle 0x0001, DMI type 1, 27 bytes
System Information
         Manufacturer: Gigabyte Technology Co., Ltd.
         Product Name: P35-DS4

Have a RAID1 and RAID5, I do not use the jmicron SATA ports, only the 
intel ones and add-on pci-e cards, never had any problems with the raid 
volumes.  The NIC is sort of flaky though [in linux], I recommend using an 
intel pci-e 1gbps card.

Justin.
