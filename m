From: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Subject: Re: [PATCH] Use disk sector size value to set offset for reading GPT
Date: Wed, 14 Dec 2016 12:04:35 +0100
Message-ID: <cd102c85-a9d5-25a9-bf2c-706310b53cc6@intel.com>
References: <1481195595-13140-1-git-send-email-mariusz.dabrowski@intel.com>
 <5850241B.8030007@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5850241B.8030007@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
Cc: jes.sorensen@redhat.com
List-Id: linux-raid.ids

Hi,
this patch affects only reading GPT from disk. It fixes minor issue when 
there
were no warning from mdadm when user was trying to create 1-disk RAID 0 with
external metadata on disk with some partitions and given array size was 
smaller
than total size of all partitions on this disk (mdadm failed to read GPT
because it was using wrong offset).

I couldn't reproduce those incidents so I can't tell that this patch 
fixes the
root cause of this issue.

Regards,
Mariusz

On 12/13/2016 05:38 PM, Wols Lists wrote:
> On 08/12/16 11:13, Mariusz Dabrowski wrote:
>> mdadm is using invalid byte-offset while reading GPT header to get
>> partition info (size, first sector, last sector etc.). Now this offset
>> is hardcoded to 512 bytes and it is not valid for disks with sector
>> size different than 512 bytes because MBR and GPT headers are aligned
>> to LBA, so valid offset for 4k drives is 4096 bytes.
>>
>> Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
> Could this be behind the couple of incidents recently, where an array
> has been moved from one machine to another, and the GPT has disappeared?
>
> I know I've been following the threads, and I've been puzzled in that
> I've thought "nothing should be writing there!"
>
> If it is, what mdadm/kernels are affected, and I can put it on the wiki,
> writing the page up about corrupted disks is next on my list.
>
> Cheers,
> Wol
>

