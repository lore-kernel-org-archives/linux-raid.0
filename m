From: Doug Dumitru <doug@easyco.com>
Subject: Re: high throughput storage server?
Date: Mon, 14 Feb 2011 18:06:43 -0800
Message-ID: <AANLkTimOjQDjoDMLSd1Z88GhOXoumtaQP4TyE=VpQmvQ@mail.gmail.com>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Matt,

You have a whole slew of questions to answer before you can decide on
a design.  This is true if you build it yourself or decide to go with
a vendor and buy a supported server.  If you do go with a vendor, the
odds are actually quite good you will end up with Linux anyway.

You state a need for 20TB of storage split among 40-50 "users".  Your
description implies that this space needs to be shared at the file
level.  This means you are building a NAS (Network Attached Storage),
not a SAN (Storage Area Network).  SANs typically export block devices
over protocols like iSCSI.  These block devices are non-sharable (ie,
only a single client can mount them (at least read/write) at a time.

So, 20TB of NAS.  Not really that hard to build.  Next, you need to
look at the space itself.  Is this all unique data, or is there an
opportunity for "data deduplication".  Some filesystems (ZFS) and some
block solutions can actively spot blocks that are duplicates and only
store a single copy.  With some applications (like virtual servers all
running the same OS), this can result in de-dupe ratios of 20:1.  If
your application is like this, your 20TB might only be 1-2 TB.  I
suspect this is not the case based on your description.

Next, is the space all the same.  Perhaps some of it is "active" and
some of it is archival.  If you need 4TB of "fast" storage and 16TB of
"backup" storage, this can really impact how you build a NAS.  Space
for backup might be configured with large (> 1TB) SATA drives running
RAID-5/6.  These configurations are good at reads and linear writes,
but lousy at random writes.  There cost is wildly lower than "fast"
storage.  You can buy a 12 bay 2U chassis for $300 plus PS and put 12
2TB 7200 RPM SATA drives raid/6 and get ~20TB of usable space.  Random
write performance will be quite bad, but for backups and "near line"
storage, it will do quite well.  You can probably build this for
around $5K (or maybe a bit less) including a 10GigE adapter and server
class components.

If you need IOPS (IO Operations Per Second), you are looking at SSDs.
You can build 20TB of pure SSD space.  If you do it yourself raid-10,
expect to pay around $6/GB or $120K just for drives.  18TB will fit in
a 4U chassis (see the 72 drive SuperMicro double-sided 4U).  72 500GB
drives later and you have 18,000 GB of space.  Not cheap, but if you
quote a system from NetApp or EMC it will seem so.

If you can cut the "fast" size down to 2-4TBs, SSDs become a lot more
realistic with commercial systems from new companies like WhipTail for
way under $100K.

If you go with hard drives, you are trading speed for space.  With
600GB 10K drives would need 66 drives raid-10.  Multi-threaded, this
would read at around 10K IOPS and write at around 7K for "small"
blocks (4-8K).  Linear IO would be wicked fast but random OPs slow you
down.  Conversly, large SSDs arrays can routinely hit > 400K reads and
> 200K writes if built correctly.  Just the 66 hard drives will run
you $30K.  These are SAS drives, not WD Velociraptors which would save
you 30%.

If you opt for "lots of small drives" (ie, 72GB 15K SAS drives) or
worse (short seek small drives), the SSDs are actually faster and
cheaper per GB.  20TB of raid-10 72GB drives is 550 drives or $105K
(just for the drives, not counting jbod enclosures, racks, etc).
Short seeking would be 1000+ drives.  I highly expect you do not want
to do this.

In terms of Linux, pretty much any stock distribution will work.
After all, you are just talking about SMB or NFS exports.  Not exactly
rocket science.

In terms of hardware, buy good disk controllers and good SAS
expanders.  SuperMicro is a good brand for motherboards and white box
chassis.  The LSI 8 channel 6gbit SAS PCIe card is a favorite as a
dumb disk controller.  The SuperMicro backplanes have LSI SAS expander
chips and work well.

The network is the easiest part.  Buy a decent dual-port 10GigE
adapter and two 24-port GigE switches with 10GigE uplink ports.  You
will max out at about 1.2 GBytes/sec on the network but should be able
to keep the GigE channels very busy.

Then you get to test, test, test.

Good Luck

Doug Dumitru
EasyCo LLC





On Mon, Feb 14, 2011 at 3:59 PM, Matt Garman <matthew.garman@gmail.com>=
 wrote:
> For many years, I have been using Linux software RAID at home for a
> simple NAS system. =A0Now at work, we are looking at buying a massive=
,
> high-throughput storage system (e.g. a SAN). =A0I have little
> familiarity with these kinds of pre-built, vendor-supplied solutions.
> I just started talking to a vendor, and the prices are extremely high=
=2E
>
> So I got to thinking, perhaps I could build an adequate device for
> significantly less cost using Linux. =A0The problem is, the requireme=
nts
> for such a system are significantly higher than my home media server,
> and put me into unfamiliar territory (in terms of both hardware and
> software configuration).
>
> The requirement is basically this: around 40 to 50 compute machines
> act as basically an ad-hoc scientific compute/simulation/analysis
> cluster. =A0These machines all need access to a shared 20 TB pool of
> storage. =A0Each compute machine has a gigabit network connection, an=
d
> it's possible that nearly every machine could simultaneously try to
> access a large (100 to 1000 MB) file in the storage pool. =A0In other
> words, a 20 TB file store with bandwidth upwards of 50 Gbps.
>
> I was wondering if anyone on the list has built something similar to
> this using off-the-shelf hardware (and Linux of course)?
>
> My initial thoughts/questions are:
>
> =A0 =A0(1) We need lots of spindles (i.e. many small disks rather tha=
n
> few big disks). =A0How do you compute disk throughput when there are
> multiple consumers? =A0Most manufacturers provide specs on their driv=
es
> such as sustained linear read throughput. =A0But how is that number
> affected when there are multiple processes simultanesously trying to
> access different data? =A0Is the sustained bulk read throughput value
> inversely proportional to the number of consumers? =A0(E.g. 100 MB/s
> drive only does 33 MB/s w/three consumers.) =A0Or is there are more
> specific way to estimate this?
>
> =A0 =A0(2) The big storage server(s) need to connect to the network v=
ia
> multiple bonded Gigabit ethernet, or something faster like
> FibreChannel or 10 GbE. =A0That seems pretty straightforward.
>
> =A0 =A0(3) This will probably require multiple servers connected toge=
ther
> somehow and presented to the compute machines as one big data store.
> This is where I really don't know much of anything. =A0I did a quick
> "back of the envelope" spec for a system with 24 600 GB 15k SAS drive=
s
> (based on the observation that 24-bay rackmount enclosures seem to be
> fairly common). =A0Such a system would only provide 7.2 TB of storage
> using a scheme like RAID-10. =A0So how could two or three of these
> servers be "chained" together and look like a single large data pool
> to the analysis machines?
>
> I know this is a broad question, and not 100% about Linux software
> RAID. =A0But I've been lurking on this list for years now, and I get =
the
> impression there are list members who regularly work with "big iron"
> systems such as what I've described. =A0I'm just looking for any kind=
 of
> relevant information here; any and all is appreciated!
>
> Thank you,
> Matt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Doug Dumitru
EasyCo LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
