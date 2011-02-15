From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: high throughput storage server?
Date: Tue, 15 Feb 2011 06:29:12 -0600
Message-ID: <4D5A7198.7060607@hardwarefreak.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>, Matt Garman <matthew.garman@gmail.com>
List-Id: linux-raid.ids

Matt Garman put forth on 2/14/2011 5:59 PM:

> The requirement is basically this: around 40 to 50 compute machines
> act as basically an ad-hoc scientific compute/simulation/analysis
> cluster.  These machines all need access to a shared 20 TB pool of
> storage.  Each compute machine has a gigabit network connection, and
> it's possible that nearly every machine could simultaneously try to
> access a large (100 to 1000 MB) file in the storage pool.  In other
> words, a 20 TB file store with bandwidth upwards of 50 Gbps.

If your description of the requirement is accurate, then what you need is a
_reliable_ high performance NFS server backed by many large/fast spindles.

> I was wondering if anyone on the list has built something similar to
> this using off-the-shelf hardware (and Linux of course)?

My thoughtful, considered, recommendation would be to stay away from a DIY build
for the requirement you describe, and stay away from mdraid as well, but not
because mdraid isn't up to the task.  I get the feeling you don't fully grasp
some of the consequences of a less than expert level mdraid admin being
responsible for such a system after it's in production.  If multiple drives are
kicked off line simultaneously (posts of such seem to occur multiple times/week
here), downing the array, are you capable of bringing it back online intact,
successfully, without outside assistance, in a short period of time?  If you
lose the entire array due to a typo'd mdadm parm, then what?

You haven't described a hobby level system here, one which you can fix at your
leisure.  You've described a large, expensive, production caliber storage
resource used for scientific discovery.  You need to perform one very serious
gut check, and be damn sure you're prepared to successfully manage such a large,
apparently important, mdraid array when things go to the South pole in a
heartbeat.  Do the NFS server yourself, as mistakes there are more forgiving
than mistakes at the array level.  Thus, I'd recommend the following.  And as
you can tell from the length of it, I put some careful consideration (and time)
into whipping this up.

Get one HP ProLiant DL 385 G7 eight core AMD Magny Cours server for deployment
as your 64 bit Linux NFS server ($2500):
http://www.newegg.com/Product/Product.aspx?Item=N82E16859105806

Eight 2.3GHz cores is actually overkill for this NFS server, but this box has
the right combination of price and other features you need.  The standard box
comes with 2x2GB DIMMs, using only 2 of the 4 channels of the occupied G34
socket, and 4GB is a tad short of what you'll need.  So toss the installed DIMMs
and buy this HP certified 4 channel 16GB kit directly from Kingston ($400):
http://www.ec.kingston.com/ecom/configurator_new/partsinfo.asp?root=us&LinkBack=http://www.kingston.com&ktcpartno=KTH-PL313K4/16G

This box has 4 GbE ports, which will give you max NFS throughput of ~600-800
MB/s bidirectional, roughly 1/3rd to half the storage system bandwidth (see
below).  Link aggregation with the switch will help with efficiency.  Set jumbo
frames across all the systems and switches obviously, MTU of 9000, or the lowest
common denominator, regardless of which NIC solution you end up with.  If that's
not enough b/w...

Add one of these PCI Express 2.0 x8 10 GbE copper Intel NICs ($600) to bump max
NFS throughput to ~1.5-2 GB/s bidirectional (assuming your switch has a copper
10 GbE port):
http://www.newegg.com/Product/Product.aspx?Item=N82E16833106043
Due to using NFS+TCP/UDP as your protocols, this NIC can't outrun the FC back
end, even though the raw signaling rate is slightly higher.  However, if you
fired up 10-12 simultaneous FTP gets you'd come really close.

Two of these for boot drives ($600):
http://www.newegg.com/Product/Product.aspx?Item=N82E16822332060
Mirror them with the onboard 256MB SmartArray BBWC RAID controller

Qlogic PCIe 2.0 x4/x8 8Gbit FC HBA ($1100):
http://www.newegg.com/Product/Product.aspx?Item=N82E16833380014&cm_re=qlogic-_-33-380-014-_-Product

for connecting to the important part ($20-40K USD):
http://www.nexsan.com/satabeast.php

42 drives in a single 4U chassis, one RAID group or many, up to 254 LUNs or just
one, awesome capacity and performance for the price.  To keep costs down yet
performance high, you'll want the 8Gbit FC single controller model with 2GB
cache (standard) and with qty 42* 1TB 7.2K rpm SATA drives.  All drives use a
firmware revision tested and certified by Nexsan for use with their controllers
so you won't have problems with drives being randomly kicked offline, etc.  This
is an enterprise class SAN controller.  (Do some research and look at Nexsan's
customers and what they're using these things for.  Caltech dumps the data from
the Spitzer space telescope to a group of 50-60 of these SATABeasts).

A SATABeast with 42 * 1TB drives should run in the ballpark of $20-40K USD
depending on the reseller and your organization status (EDU, non profit,
government, etc).  Nexsan has resellers covering the entire Americas and Europe.
 If you need to expand in the future, Nexsan offers the NXS-B60E expansion
chassis
(http://www.nexstor.co.uk/prod_pdfs/NXS-B60E_Nexsan%20NXS-B60E%20Datasheet.pdf)
which holds 60 disks and plugs into the SATABeast with redundant multilane SAS
cables, allowing up to 102 drives in 8U of rack space, 204TB total using 2TB
drives, or any combination in between.  The NXS-B60E adds no additional
bandwidth to the system.  Thus, if you need more speed and space, buy a second
SATABeast and another FC card, or replace the single port FC card with a dual
port model (or buy the dual port up front)

With the full 42 drive chassis configured as a 40 disk RAID 10 (2 spares) you'll
get 20TB usable space and you'll easily peak the 8GBit FC interface in both
directions simultaneously.  Aggregate random non-cached IOPS will peak at around
3000, cached at 50,000.  The bandwidth figures may seem low to people used to
"testing" md arrays with hdparm or dd and seeing figures of 500MB/s to 1GB/s
with only a handful of disks, however these are usually sequential _read_
figures only, on RAID 6 arrays, which have write performance often 2-3 times
lower.  In the real world, 1.6GB/s of sustained bidirectional random I/O
throughput while servicing dozens or hundreds of hosts is pretty phenomenal
performance, especially in this price range.  The NFS server will most likely be
the bottleneck though, not this storage, definitely so if 4 bonded GbE
interfaces are used for NFS serving instead of the 10 GbE NIC.

The hardware for this should run you well less than $50K USD for everything.
I'd highly recommend you create a single 40 drive RAID 10 array, as I mentioned
above with 2 spares, if you need performance as much as, if not more than,
capacity--especially write performance.  A 40 drive RAID 10 on this SATABeast
will give you performance almost identical to a 20 disk RAID 0 stripe.  If you
need additional capacity more than speed, configure 40 drives as a RAID 6.  The
read performance will be similar, although the write performance will take a big
dive with 40 drives and dual parity.

Configure 90-95% of the array as one logical drive and save the other 5-10% for
a rainy day--you'll be glad you did.  Export the logical drive as a single LUN.
 Format that LUN as XFS.  Visit the XFS mailing list and ask for instructions on
how best to format and mount it.  Use the most recent Linux kernel available,
2.6.37 or later, depending on when you actually build the NFS server--2.6.38/39
if they're stable.  If you get Linux+XFS+NFS configured and running optimally,
you should be more than impressed and satisfied with the performance and
reliability of this combined system.

I don't work for any of the companies whose products are mentioned above.  I'm
merely a satisfied customer of all of them.  The Nexsan products have the lowest
price/TB of any SAN storage products on the market, and the highest
performance/dollar, and lowest price per watt of power consumption.  They're
easy as cake to setup and manage with a nice GUI web interface over an ethernet
management port.

Hope you find this information useful.  Feel free to contact me directly if I
can be of further assistance.

-- 
Stan
