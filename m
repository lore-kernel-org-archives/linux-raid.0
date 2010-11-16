From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: read errors (in superblock?) aren't fixed by md?
Date: Tue, 16 Nov 2010 11:58:41 +0300
Message-ID: <4CE247C1.8020703@msgid.tls.msk.ru>
References: <4CDD47A7.9010501@msgid.tls.msk.ru> <20101113061227.44da7788@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101113061227.44da7788@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

12.11.2010 22:12, Neil Brown wrote:
> On Fri, 12 Nov 2010 16:56:55 +0300
> Michael Tokarev <mjt@tls.msk.ru> wrote:
> 
>> end_request: I/O error, dev sdf, sector 142655961
>> end_request: I/O error, dev sdd, sector 142656485
>>
>> Both sdf and sdd are parts of the same (raid10) array,

>> # partition table of /dev/sdf
>> unit: sectors
>> /dev/sdf1 : start=       63, size=142657137, Id=83
>>
>> Now, we've read errors on sectors 142655961 (sdf)
>> and 142656485 (sdd), which are 1239 and 715 sectors
>> before the end of the partition, respectively.
>>
>>           Magic : a92b4efc
>>         Version : 00.90.00
>>   Used Dev Size : 71328256 (68.02 GiB 73.04 GB)
>>      Array Size : 499297792 (476.17 GiB 511.28 GB)
>> Internal Bitmap : present
>>  Active Devices : 14
>>          Layout : near=2, far=1
>>      Chunk Size : 256K
>>
>> What's wrong with these read errors?  I just verified -
>> the error persists, i.e. reading the mentioned sectors
>> using dd produces the same errors again, so there were
>> no re-writes there.
>>
>> Can md handle this situation gracefully?
> 
> These sectors would be in the internal bitmap which starts at 142657095
> and ends before 142657215.
> 
> The bitmap is read from just one device when the array is assembled, then
> written to all devices when it is modified.

In this case there should be no reason to read these areas
in the first place.  The read errors happened during regular
operations, the machine had uptime of about 30 days and the
array were in use since boot.  A few days before verify pass
has been completed successfully.

> I'm not sure off-hand exactly how md would handle read errors.  I would
> expect it to just disable the bitmap, but it doesn't appear to be doing
> that... odd.  I would need to investigate more.

Again, it depends on why it tried to _read_ these areas to
start with.

> You should be able to get md to over-write the area by removing the internal
> bitmap and adding it back (with --grow --bitmap=none / --grow
> --bitmap=internal).

I tried this - no, it appears md[adm] does not write into there.
Neither of the two disks were fixed by this.

I tried to re-write them manually using dd, but it's very error-prone
so I rewrote only 2 sectors, very carefully (it appears there are more
bads in these areas, sector with the next number is also unreadable) -
and it stays fixed, drive just remapped them and increased Reallocated
Sector Count (from 0 to 2 - for a 72Gb drive this is nothing).

Since this is an important production array, I went ahead and
reconfigured it, completely - first I changed partitions to
end before the problem area (and start later too, just in case -- moved
the beginning from 63s to 1M), and created a bunch of raid1 arrays
instead of single raid10 (on the array there was Oracle database
with multiple files, so it's easy to distribute them across multiple
filesystems).

I created bitmaps again, now in a different location, let's see how
it all will work...

But there are a few questions remains still.

1) what is located in these areas?  If it is bitmap, md should
   rewrite them during bitmap creation.  Maybe the bitmap were
   smaller (I used --bitmap-chunk=4096 iirc)?  Again, if it
   were, what was in these places, and why/who tried to read it?

2) how to force mdadm to correct these, without risking to
   over-write something so that the array wont work?

3) (probably not related to md but)  It is interesting that
   several disks at once developed bad sectors in the same
   area.  From 14 drives, I noticed 5 problematic - 2 with
   real bad blocks and 3 more with long delays while reading
   these areas (this is what prompted me to reconfigure
   array).  They're even from different vendors.  In theory,
   modern hard drives should not suffer even from multiple
   writes to the same area (as it can be for high-write-
   intensive bitmap areas, but due to (1) above it isn't
   clear what is in there).  I've no explanation here.

4) (related but different)  Is there a way to force md to
   re-write or check a particular place on one of the
   components?  While trying to fix the unreadable sector
   I hit /dev/sdf somewhere in the middle and had to remove
   it from the array, remove the bitmap and add it back,
   just to be sure md will write right info into that sector...

Thanks!

/mjt
