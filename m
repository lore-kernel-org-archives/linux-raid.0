From: David Brown <david.brown@hesbynett.no>
Subject: Re: Question regarding --backup-file
Date: Mon, 02 May 2011 21:05:28 +0200
Message-ID: <ipmv9o$kcv$1@dough.gmane.org>
References: <000301cc08db$89293160$9b7b9420$@priv.hu> <4DBECEFA.1050203@fnarfbargle.com> <001501cc08ef$f60cc620$e2265260$@priv.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001501cc08ef$f60cc620$e2265260$@priv.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/05/11 19:39, Peter Kovari wrote:
>>> Hi all,
>>>
>>> I understand, that a change from RAID5 to RAID6 by adding a single disk
> -
>>> eg. keeping the number of data disks - requires a backup file throughout
> the
>>> whole reshape process. For a larger, multi-TB array this means millions
> of
>>> writes to the backup file, which - if i'm correct - means means millions
> of
>>> writes to the same physical sectors of the disk that holds the backup
> file.
>>> Is this not problematic? How many write operations can a typical drive
>>> tolerate nowadays? (on the same sectors)
>
>> Lots, where Lots>= 1 and Lots<  infinity.
>
>> I've never seen rotating media specify any form of limitation to writes.
>> Have you?
>
> No, that's why i'm asking.
>
> Imho, in typical usage, write cycle counts on a certain sector may not be
> that high, even on a database server. I doubt it ever goes over a few
> hundred thousands during the life cycle of the hard disk. On the other hand,
> a single reshape on a larger array can trigger tens of millions of write
> cycles on certain sectors. Sectors do fail eventually, so I'm wondering if
> the "no limit" is truly a no limit, or manufacturers just won't state this
> info because in "normal" usage, customers will never reach that limit.
>
> Btw, i'm sure SSD's are not meant to take such a pressure.
>

Good large SSD's can be written to continuously for /years/ before they 
wear out.  It can be a different matter for smaller and cheapo drives, 
but it's not an issue for good disks now.  Suppose you have a 128 GB 
disk with SLC flash.  Each sector is good for roughly 100,000 
erase/re-write cycles (or more, if you are kind to the disk and keep it 
cool).  Since wear-leveling spreads the writes around the disk, you can 
write 100,000 x 128 GB of data - at 200 MB/s continuously, that would 
take 2 years without a pause for breath.  Even if the wear-leveling 
isn't perfect, and even if you substitute a cheaper MLC SSD (with 10,000 
cycles), the effort of being the backup file for a raid reshape is not 
going to be a challenge.

Also, some SSD's have super-cap backed up ram caches - writes can be 
safely buffered before being written.  If you overwrite the same sector 
fast enough, it will never actually be written to the flash (until the 
final write, of course).

For hard disks, sectors do wear out, but they tolerate a lot of writes 
first.  And the hard disk firmware will re-locate the worn out sector 
transparently.


