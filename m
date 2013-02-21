From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Wed, 20 Feb 2013 18:45:57 -0600
Message-ID: <51256E45.5080707@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <d34a6caf-d1b5-403c-aee2-525a9b3c3db7@email.android.com> <51179F09.1020503@hardwarefreak.com> <6990fbda-f741-454a-80cd-bdcdfd8c971c@email.android.com> <5119AD1C.8030000@hardwarefreak.com> <5119D410.5090300@websitemanagers.com.au> <511B4719.6060607@hardwarefreak.com> <aecd39d9-2184-4df0-97bb-d63de0d29e5c@email.android.com> <555253fb-86d2-448b-a85b-43dae1a2a33d@email.android.com> <511CD709.6070506@hardwarefreak.com> <511E38C7.6000203@hardwarefreak.com> <c0057008-8681-4275-a6e2-e747c9711158@email.android.com> <511EDBCB.2000906@hardwarefreak.com> <bdc9707d-f948-430e-b1e6-28ad06bbe60a@email.android.com> <5120356E.8000702@hardwarefreak.com> <91cffde0-b154-477d-90d2-68b15e91518c@email.android.com> <5120789B.1080804@hardwarefreak.com> <5120979C
 .9030703@websitemanagers.com.au> <5120E1F6.2050906@hardwarefreak.com> <5120ED3F.7080904@websitemanagers.com.au> <5123351F.5030903@hardwarefreak.com> <5124FDB2.10007@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5124FDB2.10007@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/20/2013 10:45 AM, Adam Goryachev wrote:
> Stan Hoeppner <stan@hardwarefreak.com> wrote:

> Same ssd in both tests. fio command line was just fio test.fio
> The fio file was the one posted in this thread by another user as follows:
> [global]
> bs=64k
> ioengine=libaio
> iodepth=32

Try dropping the iodepth to 4 and see what that does.

> size=4g
> direct=1
> runtime=60
> #directory=/dev/vg0/testlv
> filename=/tmp/testing/test
> 
> [seq-read]
> rw=read
> stonewall
> 
> [seq-write]
> rw=write
> stonewall
> 
> Note, the "root ssd" is the /tmp/testing/test file, when testing MD
> performance on the RAID5 I'm using the /dev/vg0/testlv which is an LV on
> the DRBD on the RAID5 (md2), and I do the test with the DRBD disconnected.

Yes, and FIO performance to a file is going to be limited by the
filesystem, and specifically the O_DIRECT implementation in that FS.
You may see significantly different results from EXT2/3/4, Reiser, than
from XFS or JFS, and from different kernel and libaio versions as well.
 There are too many layers between FIO and the block device, so it's
difficult to get truly accurate performance data for the underlying device.

And in reality, all of your FIO testing should be random, not
sequential, as your workload is completely random--this is a block IO
server after all with 8 client hosts and I assume hundreds of users.

The proper way to test the capability of your iSCSI target server is to
fire up 8 concurrent FIO tests, one on each Xen box (or VM), each
running 8 threads and using random read/write IO, with each hitting a
different test file residing on a different LUN, while using standard OS
buffered IO.  Run a timed duration test of say 15 seconds.

Testing raw sequential throughput of a device (single SSD or single LUN
atop a single LV on a big mdRAID device) is not informative at all.

>> WTF? How did you accomplish the upgrades?  Why didn't you flip it over
>> at that time?  Wow....
> 
> A VERY good question, both of them.... I worked like a mechanic, from
> underneath... a real pain I would say. I didn't like the idea of trying
> to flip it by myself though, much better with someone else to help in
> the process.... I think my supplier gives me crappy rails/solutions,
> because they are always a pain to get them installed....

I dog ear 2KVA UPSes in the top of 42U racks solo and have never had a
problem mounting any slide rail server.  I often forget that most IT
folks aren't also 6'4" 190lbs, and can't do a lot of racking work solo.

>> Definitely cheaper, and more flexible should you need to run a filer
>> (Samba) directly on the box.  Not NEARLY as easy to setup.  Nexsan has
>> some nice gear that's a breeze to configure, nice intuitive web GUI.
> 
> The breeze to configure part would be nice :)

When you're paying that much premium it better come with some good value
added features.

> We have 10Mbps private connection. I think we can license the DRBD proxy
> which should handle the sync over a slower network. The main issue with
> DRBD is when you are not using the DRBD proxy.... The connection itself
> is very reliable though, 

10Mbps isn't feasible for 2nd site block level replication, with DRBD
proxy or otherwise.  It's probably not even feasible for remote file
based backup.

BTW, what is the business case driver here for off site replication, and
what is the distance to the replication site?  What is the threat
profile to the primary infrastructure?  Earthquake?  Tsunami?  Flash
flooding?  Tornado?  Fire?

I've worked for and done work for businesses of all sizes, the largest
being Mastercard.  Not a one had offsite replication, and few did
network based offsite backup.  Those doing offsite other than network
based performed tape rotation to vault services.

That said, I'm in the US midwest.  And many companies on the East and
West coasts do replication to facilities here.  Off site
replication/backup only makes since when the 2nd facility is immune to
all natural disasters, and hardened against all types of man made ones.
 If you replicate to a site in the same city or region with the same
thread profile, you're pissing in the wind.

Off site replication/backup exists for a singular purpose:

To protect against catastrophic loss of the primary facility and the
data contained therein.

Here in the midwest, datacenters are typically built in building
basements or annexes and are fireproofed, as fire is the only facility
threat.  Fireproofing is much more cost effective than the myriad things
required for site replication and rebuilding a primary site after loss
due to fire.

> just a matter of the bandwidth and whether it
> will be sufficient. I'll test beforehand by using either the switch or
> linux to configure a slower connection (maybe 7M or something), and see
> if it will work reasonably.

I highly recommend you work through the business case for off site
replication/DR before embarking down this path.

> I've preferred AMD for years, but my supplier always prefers Intel, and

Of course, they're an IPD - Intel Product Dealer.  They get kickbacks
and freebies from the IPD program, including free product samples,
advance prototype products, promotional materials, and, the big one, 50%
of the cost of print, radio, and television ads that include Intel
product and the logo/jingle.  You also get tiered pricing depending on
volume, no matter how small your shop is.  And of course Intel holds IPD
events in major cities, with free food, drawings, door prizes, etc.  I
won a free CPU (worth $200 retail at the time) at the first one I
attended.  I know all of this in detail because I was the technician of
record when the small company I was working for signed up for the IPD
program.  Intel sells every part needed to built a server or workstation
but for the HDD and memory.  If a shop stocks/sells all Intel parts
program points add up more quickly.  In summary, once you're an IPD,
there is disincentive to sell anything else, especially if you're a
small shop.

> for systems like this they get much better warranty support for Intel
> compared to almost any other brand, so I generally end up with Intel
> boards and CPU's for "important" servers... Always heard good things
> about Intel NIC's ...

So you're at the mercy of your supplier.

FYI.  Intel has a tighter relationship with SuperMicro than any mobo
manufacturer.  For well over a decade Intel has tapped SM to build all
Intel prototype boards as Intel doesn't have a prototyping facility.
And SM contract manufacturers over 50% of all Intel motherboards.  Mobo
mf'ing is a low margin business compared to chip fab'ing, which is why
Intel never built up a large mobo mf'ing capability.  The capital cost
for the robots used in mobo making is as high as CPU building equipment,
but the profit per unit is much lower.

This relationship is the reason Intel was so upset when SM started
offering AMD server boards some years ago, and why at that time one had
to know the exact web server subdir in which to find the AMD
products--SM was hiding them for fear of Chipzilla's wrath.  Intel's
last $1.25B antitrust loss to AMD in '09 emboldened SM to bring their
AMD gear out of hiding and actually promote it.

In short, when you purchase a SuperMicro AMD based server board the
quality and compatibility is just as high as when buying a board with
Intel's sticker on it.  And until Sandy Bridge CPUs hit, you got far
more performance from the AMD solution as well.

-- 
Stan

