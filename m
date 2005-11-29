From: Brad Dameron <brad@seatab.com>
Subject: Re: building a disk server
Date: Mon, 28 Nov 2005 17:01:33 -0800
Message-ID: <1133226093.4149.18.camel@dhcpc226.office.pivotlink.com>
References: <7f55de720511281555s6b30355atf2b943b5148b8c37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7f55de720511281555s6b30355atf2b943b5148b8c37@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2005-11-28 at 16:55 -0700, Sebastian Kuzminsky wrote:
> Hi folks, I want to pick your brains.  I'm building a new disk server
> for a small company, about 20 people.  We need about 2 TB now and
> maybe another 2 TB in a year or so.  Price is a factor, but
> reliability is more important.
> 
> I'm planning to build a server-class PC from parts, and use the
> standard RAID + LVM setup for growing the disk space in the future. 
> Does this seem reasonable?
> 
> I'm planning to use SATA disks, because they seem to offer a good
> balance between performance, price, and reliability.  I wish Linux
> SATA supported SMART and hotplug!  I've had several drive failures
> with Maxtor 300 GB PATA and 320 GB SATA disks this year, what's a more
> reliable drive people use?  I'd prefer to buy fewer, higher-capacity
> drives (300+ GB).  Any experience with the new 500's?
> 
> I'm planning to put all the disks in a big tower case like the
> CoolerMaster Stacker
> <http://www.coolermaster-usa.com/CoolerMaster/ProductList.aspx?catID=614>,
> probably using the CoolerMaster 3-to-4 disk adapter.  I'd like dual,
> redundant power supplies.  Any particular cases & power supplies work
> well for y'all?
> 
> Some sort of name-brand motherboard & CPU, about 2 GB RAM, and I'm done!
> 
> SATA disk controllers usually come in 2x, 4x, and 8x versions, so
> there's a slight advantage to building arrays that use those numbers
> of disks.  I've mostly been using 4-disk RAID-5 arrays in the past,
> but I'd like more redundancy.  4-disk RAID-6 seems is an option, as is
> 8-disk RAID-6 with a hot spare.  What else should I be considering?
> 
> Am I on the right track here?  I'm worried that I'm just scaling up my
> home setup, maybe I'm missing an opportunity to do something smarter
> here.
> 
> --
> Sebastian Kuzminsky

Might look at a Areca SATA RAID controller. They support up to 24 ports
and has hardware level RAID capacity expansion. Or if you want to go
cheaper look at the 3ware controller and use it in JBOD. That way you
can get the Smart monitoring and hotplug. 

Here is the server I built with 3TB usable for pretty cheap.
All this was from www.8anet.com

Supermicro SC933T-R760 3u or SC932T-R760 rackmount Chassis with 15 SATA
Hot-Swap drive trays and triple redundant power supplies.
Any motherboard and CPU will do. I would recommend a AMD64 CPU with a
motherboard that has a PCI-X slot on it if possible. I used a Tyan S2468
with dual Athlon 2800's and 2GB. 
A 3ware 9500S-12. Not the 9500S-12MI with this case. Or the new
9550SX-12 which is much faster now.
12 - 300GB Maxtor MaXLine III drives
2 - Western Digital 36GB 10k drives


I use the 2 36GB drives mirrored for the OS since I had the extra slots.
Could of went with a Areca 16 port card instead. But I already had the
3ware laying around. I went with the 300GB Maxtor drives because at the
time they were the ones that had SATAII NCQ (Native Command Queuing) and
16MB cache. This setup is very fast and I use it as a NFS server for
backing up my main servers. I currently have about 20% left out of 3TB.
Time to add another one. 

Hope this helps.

Brad Dameron
SeaTab Software
www.seatab.com  

