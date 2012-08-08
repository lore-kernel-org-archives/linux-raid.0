From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID10 Performance
Date: Wed, 08 Aug 2012 11:59:57 -0500
Message-ID: <50229B0D.5070201@hardwarefreak.com>
References: <50115123.1020900@websitemanagers.com.au> <50123E2C.8090108@hardwarefreak.com> <50129176.3050604@websitemanagers.com.au> <5012DE22.10108@hardwarefreak.com> <50138853.5030100@websitemanagers.com.au> <50140657.8010802@hardwarefreak.com> <5021E1BC.3060607@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5021E1BC.3060607@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/7/2012 10:49 PM, Adam Goryachev wrote:
> Just some followup questions, hopefully this isn't too off-topic for
> this list, if it is please let me know.

> OK, with the given budget, we currently have a couple of options:
> 1) Replace the primary SAN (which currently has 2 x 2TB WD Caviar Black
> RE4 drives in RAID1 + a hot spare) with 5 x 1TB Raptors you suggested
> above (4 x 1TB in RAID10 + 1 hot spare).

Wow, that is a tight budget.  You'll be increasing total IOPS by about
3x with 4 10k drives.  Probably not optimal for your workload but it's a
good start.

Also, don't use a hot spare--just wastes ports, cages, dollars.  It's
not needed with RAID10.  Keep a spare in a locked cabinet and hot swap
the drives upon failure notification.  RAID10 has a very large "double
drive failure kills array" window, like many months to years.

BTW, Caviar Black != RE4  They're different products.

> 2) Replace the primary SAN with 3 x 480GB SSD drives in linear + one of
> the existing 2TB drives combined as RAID1 with the 2TB drive in write
> only mode. This reduces overall capacity, but it does provide enough
> capacity for at least 6 to 12 months. If needed, one additional SSD will
> provide almost 2TB across the entire san.

This is simply insane, frankly.  Don't attempt this, even if md does
support a write only mirror partner.

> Further expansion becomes expensive, but this enterprise doesn't have a
> lot of data growth (over the past 10 years), so I don't expect it to be
> significant, also given the rate of increasing SSD storage, and
> decreasing cost. Long term it would be ideal to make this system use 8 x
> 480G in RAID10, and eventually another 8 on the secondary SAN.

Wait until *enterprise* SSD is fully mature and less expensive.  Stick
with mechanical storage for now as your budget doesn't support SSD.
If/when you go SSD, go *all* SSD, not this asymmetric Frankenstein
stuff, which will only cause you problems.

> I'm aware that a single SSD failure will reduce performance back to
> current levels.

Then why would you ever consider this?  This thread is about increasing
performance.  Why would you build a system that will instantly decrease
IOPS by a factor of 1000 upon device failure?  That's insane.

>> And don't use the default 512KB chunk size of metadata 1.2.  512KB per
>> chunk is insane.  With your Win server VM workload, where no server does
>> much writing of large files or at a sustained rate, usually only small
>> files, you should be using a small chunk size, something like 32KB,
>> maybe even 16KB.  If you use a large chunk size you'll rarely be able to
>> fill a full stripe write, and you'll end up with IO hot spots on
>> individual drives, decreasing performance.
> 
> I'm assuming that this can't be changed?

You assume what can't be changed?  Define what is changing.  It's a
simple command line switch to change the chunk size from the default.
See man mdadm.

> Currently, I have:
> md RAID
> DRBD
> LVM
> 
> Could I simply create a new MD array with the smaller chunk size, tell

So you're asking how to migrate from the current disks to the new disks?
 Yes you obviously must create a new RAID10 array.  Do you have enough
SAS/SATA ports to have all (2+4) disks running?  If so this should be
straightforward but will require some downtime.

> DRBD to sync from the remote to this new array, and then do the same for
> the other SAN?

Don't do this over ethernet.  What I would do is simply shut down all
daemons that may write to the current array, make it "static".  Shut
down DRBD on both hosts.  Use dd or a partition tool to copy everything
from the 2TB md/RAID1 mirror to the new 4 drive array.  Change your
mounts etc to the new RAID10 device.  Down the 2TB mirror array.
Confirm the new array is working.  Delete the current DRBD configuration
on both hosts and create a new one.  Start DRBD on both hosts and as its
syncing up restart services.

> Would this explain why one drive has significantly more activity now? I
> don't think so, since it is really just a 2 disk RAID1, so both drives
> should be doing the same writes, and both drives should be servicing the
> read requests. This doesn't seem to be happening, during very high read
> IO this morning (multiple VM's running a full antivirus scan
> simultaneously), one drive activity light was "solid" and the second was
> "flashing slowly".

md/RAID1 doesn't guarantee symmetric read IO across members of the pair.
 RAID1 isn't for high performance.  It's for cheap redundancy.  Even
RAID0 can exhibit this behavior if you have a large chunk size and lots
of small files.  They tend to align to the first drive in the stripe
because they fit entirely within the chunk.  This is why a default 512KB
chunk is insane for most workloads, especially mail servers.

> Added to this, I've just noticed that the array is currently doing a
> "check", would that explain the drive activity and also reduced
> performance?

Of course.

> My direct emails to you bounced due to my mail server "losing" it's
> reverse DNS. That is a local matter, delayed while "proving" we have
> ownership of the IP space to APNIC.

I see all your list messages so we're good to go.  Better to keep
discussion on list anyway so others can learn, participate, and it gets
archived.

> Thanks again for your advise.

You're welcome.

-- 
Stan

