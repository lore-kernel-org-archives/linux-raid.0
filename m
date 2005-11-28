From: Sebastian Kuzminsky <seb.kuzminsky@gmail.com>
Subject: building a disk server
Date: Mon, 28 Nov 2005 16:55:30 -0700
Message-ID: <7f55de720511281555s6b30355atf2b943b5148b8c37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks, I want to pick your brains.  I'm building a new disk server
for a small company, about 20 people.  We need about 2 TB now and
maybe another 2 TB in a year or so.  Price is a factor, but
reliability is more important.

I'm planning to build a server-class PC from parts, and use the
standard RAID + LVM setup for growing the disk space in the future. 
Does this seem reasonable?

I'm planning to use SATA disks, because they seem to offer a good
balance between performance, price, and reliability.  I wish Linux
SATA supported SMART and hotplug!  I've had several drive failures
with Maxtor 300 GB PATA and 320 GB SATA disks this year, what's a more
reliable drive people use?  I'd prefer to buy fewer, higher-capacity
drives (300+ GB).  Any experience with the new 500's?

I'm planning to put all the disks in a big tower case like the
CoolerMaster Stacker
<http://www.coolermaster-usa.com/CoolerMaster/ProductList.aspx?catID=614>,
probably using the CoolerMaster 3-to-4 disk adapter.  I'd like dual,
redundant power supplies.  Any particular cases & power supplies work
well for y'all?

Some sort of name-brand motherboard & CPU, about 2 GB RAM, and I'm done!

SATA disk controllers usually come in 2x, 4x, and 8x versions, so
there's a slight advantage to building arrays that use those numbers
of disks.  I've mostly been using 4-disk RAID-5 arrays in the past,
but I'd like more redundancy.  4-disk RAID-6 seems is an option, as is
8-disk RAID-6 with a hot spare.  What else should I be considering?

Am I on the right track here?  I'm worried that I'm just scaling up my
home setup, maybe I'm missing an opportunity to do something smarter
here.

--
Sebastian Kuzminsky
