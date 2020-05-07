From: Michal Soltys <msoltyspl@yandex.pl>
Subject: [general question] rare silent data corruption when writing data
Date: Thu, 7 May 2020 19:30:19 +0200
Message-ID: <b0e91faf-3a14-3ac9-3c31-6989154791c1@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US-large
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Note: this is just general question - if anyone experienced something similar or could suggest how to pinpoint / verify the actual cause.

Thanks to btrfs's checksumming we discovered somewhat (even if quite rare) nasty silent corruption going on on one of our hosts. Or perhaps "corruption" is not the correct word - the files simply have precise 4kb (1 page) of incorrect data. The incorrect pieces of data look on their own fine - as something that was previously in the place, or written from wrong source.

The hardware is (can provide more detailed info of course):

- Supermicro X9DR7-LN4F
- onboard LSI SAS2308 controller (2 sff-8087 connectors, 1 connected to backplane)
- 96 gb ram (ecc)
- 24 disk backplane

- 1 array connected directly to lsi controller (4 disks, mdraid5, internal bitmap, 512kb chunk)
- 1 array on the backplane (4 disks, mdraid5, journaled)
- journal for the above array is: mdraid1, 2 ssd disks (micron 5300 pro disks)
- 1 btrfs raid1 boot array on motherboard's sata ports (older but still fine intel ssds from DC 3500 series)

Raid 5 arrays are in lvm volume group, and the logical volumes are used by VMs. Some of the volumes are linear, some are using thin-pools (with metadata on the aforementioned intel ssds, in mirrored config). LVM
uses large extent sizes (120m) and the chunk-size of thin-pools is set to 1.5m to match underlying raid stripe. Everything is cleanly aligned as well.

With a doze of testing we managed to roughly rule out the following elements as being the cause:

- qemu/kvm (issue occured directly on host)
- backplane (issue occured on disks directly connected via LSI's 2nd connector)
- cable (as a above, two different cables)
- memory (unlikely - ECC for once, thoroughly tested, no errors ever reported via edac-util or memtest)
- mdadm journaling (issue occured on plain mdraid configuration as well)
- disks themselves (issue occured on two separate mdadm arrays)
- filesystem (issue occured on both btrfs and ext4 (checksumed manually) )

We did not manage to rule out (though somewhat _highly_ unlikely):

- lvm thin (issue always - so far - occured on lvm thin pools)
- mdraid (issue always - so far - on mdraid managed arrays)
- kernel (tested with - in this case - debian's 5.2 and 5.4 kernels, happened with both - so it would imply rather already longstanding bug somewhere)

And finally - so far - the issue never occured:

- directly on a disk
- directly on mdraid
- on linear lvm volume on top of mdraid

As far as the issue goes it's:

- always a 4kb chunk that is incorrect - in a ~1 tb file it can be from a few to few dozens of such chunks
- we also found (or rather btrfs scrub did) a few small damaged files as well
- the chunks look like a correct piece of different or previous data

The 4kb is well, weird ? Doesn't really matter any chunk/stripes sizes anywhere across the stack (lvm - 120m extents, 1.5m chunks on thin pools; mdraid - default 512kb chunks). It does nicely fit a page though ...

Anyway, if anyone has any ideas or suggestions what could be happening (perhaps with this particular motherboard or vendor) or how to pinpoint the cause - I'll be grateful for any.
