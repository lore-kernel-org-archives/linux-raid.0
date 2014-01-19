From: Phil Turmel <philip@turmel.org>
Subject: Re: If separate md for /boot, OS, and /srv, must 'create' on disks
 with 3 partns?
Date: Sun, 19 Jan 2014 15:46:31 -0500
Message-ID: <52DC39A7.5020506@turmel.org>
References: <52DC1BED.7070901@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52DC1BED.7070901@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ron Leach <ronleach@tesco.net>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Ron,

On 01/19/2014 01:39 PM, Ron Leach wrote:
> List, may I ask a query about partitions?

Of course!

> Our objective is to run a Debian Wheezy system as a data server using an
> LVM on top of 2 x 3TB discs in RAID-1 configuration.  A first attempt
> had the whole discs used for the data filesystem, using a single
> /dev/md(n), on whole unpartitioned disks.  We've dismantled that because
> of filesystem size problems (it had used only 2TB disks) and will make a
> second attempt and additionally, this time, we want to use the array for
> 3 purposes:
> 
> (a) Boot with Grub
> (b) Hold the OS
> (c) Use the remainder of the disk for the data server, on which we'll
> install an LVM and later grow that with another 2 x 3TB disks.

This kind of setup is fine for light duties (like my personal servers),
but may cause you significant grief if you need to do high-bandwidth
streaming.

(a) is insignificant, as it is only touched at boot or update.

(b) is a random-access workload that tends to spike near and after RAM
exhaustion.  Lots of seeks when busy.

(c) is unspecified here, but streaming workloads often cause RAM
exhaustion as the cache fills.  Then the seeks of the random-access
workload crush the total bandwidth of the drives involved.

> Assuming I am correct in needing something such as:
> 
> /dev/md0 for Grub, (and copied to both physical disks of the RAID-1)
> /dev/md1 for the OS, and

I would use LVM here, too.

> /dev/md2 for the data files (on which we'll install the LVM)
> 
> then I think we need to partition our disks before creating the array.
>  Is that correct?

Yes.

> The wiki ( https://raid.wiki.kernel.org/index.php/Partition_Types , and
> https://raid.wiki.kernel.org/index.php/RAID_setup#General_setup ) is
> relatively silent on the 'numbers' of partitions that could or should be
> used, if creating a raid on new discs in the circumstances where boot
> 'partitions' and separate OS 'partitions' might be needed.  I couldn't
> see anything in man mdadm to guide me, either, but I could have missed
> something and apologies if I have.

Partitioning is not recommended for arrays with heavy-duty workloads.
Mixing workload types on the same spinning disks gets you worst-case
performance for both types.  It doesn't matter for SSDs, but that's
rather expensive in large capacities.

> Should I proceed to partition the disks, and then create 3 RAID-1 arrays
> (one on each partition-pair), or should I use a different
> technique/layout to hold Grub, the OS, and an expandable LV for the
> datafiles?

How were you booting when the two disks were a single array?  Some other
device?  If you can still do that, consider it.

> I had always assumed that /dev/md(x) always mapped to /dev/sda(y), but I
> have a faint recollection that a discussion on the list a year or so ago
> had suggested that that mapping was not cast in stone, and multiple
> partitions on the physical devices were neither necessary nor
> desirable.  Grateful for any comment,  Ron

MD simply makes arrays out of block devices.  It doesn't care,
logically, whether those are whole disks, partitions, loopbacks devices,
or other layered devices.

For the small systems I've built lately, I've set up modest twin SSDs to
handle boot, root, swap, database tablespaces, and mail storage.  Then
added four or more large drives to handle media files.  The SSDs have a
small partition for grub (raid1) and the balance in a single raid1 for
LVM.  The large drives are typically unpartitioned, making a large
raid6, raid10,f3, or raid10,n3.  (In my opinion, large drives aren't
safe with less than double redundancy.)

Oh, and don't forget a backup plan.  Raid redundancy is *not* backup.

If you have bigger goals in mind, ignore me--do whatever Stan says
(seriously).

HTH,

Phil
