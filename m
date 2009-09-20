From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Random bit flips - better data integrity needed [Was: Re: 	mismatch_count
 != 0 on multiple hosts]
Date: Sun, 20 Sep 2009 10:36:08 +0100
Message-ID: <4AB5F788.6090701@anonymous.org.uk>
References: <87f94c370909190910s6992a671re507ddcf91ea623e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370909190910s6992a671re507ddcf91ea623e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/09/2009 17:10, Greg Freemyer wrote:
[...]
> I don't know how specifically, but it also seems to me the mdraid
> stack could add to currently poor data integrity process even in the
> absence of a supporting scsi subsystem.  Maybe by pulling out the
> integrity checksum / crc info and putting it on yet another disk, or
> mixing it in with the parity calculation.
> 
> Specifically you could steal the second parity stripe from a raid 6
> setup and replace it with this end-to-end data integrity checksum /
> crc.  The checksum / crc is much smaller than the original data so the
> one integrity disk should support a reasonable number of data disks.
> Obviously this would not be one of the formal raid levels, but that
> doesn't mean its not useful.

I vaguely remember someone here was prototyping/developing a device 
mapper thingy which added checksumming/integrity to simulate high-end 
RAID cards adding a checksum to each 512-byte sector by using 520- or 
528-byte sectors on their component discs. I don't remember the details, 
but what I have in mind was something along the lines of using an extra 
sector on the underlying device per 64 sectors or so. There wouldn't be 
too heavy an overhead on small reads - we do readahead anyway - and it 
would make small writes even more painful than they are already, but 
shouldn't significantly reduce throughput on large (chunk size) reads 
and writes. I'd use it.

Cheers,

John.
