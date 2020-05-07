From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: [general question] rare silent data corruption when writing data
Date: Fri, 8 May 2020 00:13:54 +0200
Message-ID: <6ac333fb-c5e1-c934-a153-8caa6dc4b275@yandex.pl>
References: <b0e91faf-3a14-3ac9-3c31-6989154791c1@yandex.pl>
 <CAAMCDef6hKJsPw3738KJ0vEEwnVKB-QpTMJ6aSeybse-4h+y6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDef6hKJsPw3738KJ0vEEwnVKB-QpTMJ6aSeybse-4h+y6Q@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/05/07 20:24, Roger Heflin wrote:
> Have you tried the same file 2x and verified the corruption is in the
> same places and looks the same?

Yes, both with direct tests on hosts and with btrfs scrub failing on the 
same files in exactly same places. Always full 4KiB chunks.

> 
> I have not as of yet seen write corruption (except when a vendors disk
> was resetting and it was lying about having written the data prior to
> the crash, these were ssds, if your disk write cache is on and you
> have a disk reset this can also happen), but have not seen "lost
> writes" otherwise, but would expect the 2 read corruption I have seen
> to also be able to cause write issues.  So for that look for scsi
> notifications for disk resets that should not happen.
> 

When I was doing a simple test that basically was:

while .....; do
  rng=$((hexdump ..... /dev/urandom))
  dcfldd hash=md5 textpattern=$((rng_value)) of=/dst/test bs=262144 
count=$((16*4096))
  sync
  echo 1>/proc/sys/vm/drop_caches
  dcfldd hash=md5 if=/dst/test of=/dev/null .....
  compare_hashes_and_stop_if_different
done

There was no worrysome resets/etc. entries in dmesg.


> I have had a "bad" controller cause read corruptions, those
> corruptions would move around, replacing the controller resolved it,
> so there may be lack of error checking "inside" some paths in the
> card.  Lucky I had a number of these controllers and had cold spares
> for them.  The give away here was 2 separate buses with almost
> identical load with 6 separate disks each and all12 disks on 2 buses
> had between 47-52 scsi errors, which points to the only component
> shared (the controller).

Doesn't seem to be the case here, the reads are always the same - both 
in content and position.

> 
> I have had pre-pcie bus (PCI-X bus, 2 slots shared, both set to 133
> cause random read corruptions, lowering speed to 100 fixed it), this
> one was duplicated on multiple identical pieces of hw with all
> different parts on the duplication machine.
> 
> I have also seen lost writes (from software) because someone did a
> seek without doing a flush which in some versions of the libs loses
> the unfilled block when the seek happens (this is noted in the man
> page, and I saw it 20years ago, it is still noted in the man page, so
> no idea if it was ever fixed).  So has more than one application been
> noted to see the corruption?
> 
> So one question, have you seen the corruption in a path that would
> rely on one controller, or all corruptions you have seen involving
> more than one controller?  Isolate and test each controller if you
> can, or if you can afford to replace it and see if it continues.
> 

So far only on one (LSI 2308) controller - although the thin volumes' 
metadata is on the ssds connected to chipset's sata controller. Still if 
hypothetically that was the case (metadata disks), wouldn't I rather see 
some kind of corruptions that would be a multiple of thin-volume's chunk 
size (so multiplies of 1.5 MiB in this case).

As for controler, I have ordered another one that we plan to test in 
near future.

> 
> On Thu, May 7, 2020 at 12:33 PM Michal Soltys <msoltyspl@yandex.pl> wrote:
>>
>> Note: this is just general question - if anyone experienced something similar or could suggest how to pinpoint / verify the actual cause.
>>
>> Thanks to btrfs's checksumming we discovered somewhat (even if quite rare) nasty silent corruption going on on one of our hosts. Or perhaps "corruption" is not the correct word - the files simply have precise 4kb (1 page) of incorrect data. The incorrect pieces of data look on their own fine - as something that was previously in the place, or written from wrong source.
>>
>> The hardware is (can provide more detailed info of course):
>>
>> - Supermicro X9DR7-LN4F
>> - onboard LSI SAS2308 controller (2 sff-8087 connectors, 1 connected to backplane)
>> - 96 gb ram (ecc)
>> - 24 disk backplane
>>
>> - 1 array connected directly to lsi controller (4 disks, mdraid5, internal bitmap, 512kb chunk)
>> - 1 array on the backplane (4 disks, mdraid5, journaled)
>> - journal for the above array is: mdraid1, 2 ssd disks (micron 5300 pro disks)
>> - 1 btrfs raid1 boot array on motherboard's sata ports (older but still fine intel ssds from DC 3500 series)
>>
>> Raid 5 arrays are in lvm volume group, and the logical volumes are used by VMs. Some of the volumes are linear, some are using thin-pools (with metadata on the aforementioned intel ssds, in mirrored config). LVM
>> uses large extent sizes (120m) and the chunk-size of thin-pools is set to 1.5m to match underlying raid stripe. Everything is cleanly aligned as well.
>>
>> With a doze of testing we managed to roughly rule out the following elements as being the cause:
>>
>> - qemu/kvm (issue occured directly on host)
>> - backplane (issue occured on disks directly connected via LSI's 2nd connector)
>> - cable (as a above, two different cables)
>> - memory (unlikely - ECC for once, thoroughly tested, no errors ever reported via edac-util or memtest)
>> - mdadm journaling (issue occured on plain mdraid configuration as well)
>> - disks themselves (issue occured on two separate mdadm arrays)
>> - filesystem (issue occured on both btrfs and ext4 (checksumed manually) )
>>
>> We did not manage to rule out (though somewhat _highly_ unlikely):
>>
>> - lvm thin (issue always - so far - occured on lvm thin pools)
>> - mdraid (issue always - so far - on mdraid managed arrays)
>> - kernel (tested with - in this case - debian's 5.2 and 5.4 kernels, happened with both - so it would imply rather already longstanding bug somewhere)
>>
>> And finally - so far - the issue never occured:
>>
>> - directly on a disk
>> - directly on mdraid
>> - on linear lvm volume on top of mdraid
>>
>> As far as the issue goes it's:
>>
>> - always a 4kb chunk that is incorrect - in a ~1 tb file it can be from a few to few dozens of such chunks
>> - we also found (or rather btrfs scrub did) a few small damaged files as well
>> - the chunks look like a correct piece of different or previous data
>>
>> The 4kb is well, weird ? Doesn't really matter any chunk/stripes sizes anywhere across the stack (lvm - 120m extents, 1.5m chunks on thin pools; mdraid - default 512kb chunks). It does nicely fit a page though ...
>>
>> Anyway, if anyone has any ideas or suggestions what could be happening (perhaps with this particular motherboard or vendor) or how to pinpoint the cause - I'll be grateful for any.
> 
