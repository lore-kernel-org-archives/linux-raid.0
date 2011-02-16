From: Joe Landman <joe.landman@gmail.com>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 17:12:56 -0500
Message-ID: <4D5C4BE8.5040502@gmail.com>
References: <20110216212751.51a294aa@notabene.brown>	<4D5BDB84.8050706@gmail.com>	<20110217082412.51afa2a6@notabene.brown> <20110217024402.1dd44267@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217024402.1dd44267@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/2011 04:44 PM, Roman Mamedov wrote:
> On Thu, 17 Feb 2011 08:24:12 +1100
> NeilBrown<neilb@suse.de>  wrote:
>
>> "read/write/compare checksum" is not a lot of words so I may well not be
>> understanding exactly what you mean, but I guess you are suggesting that we
>> could store (say) a 64bit hash of each 4K block somewhere.
>> e.g. Use 513 4K blocks to store 512 4K blocks of data with checksums.
>> When reading a block, read the checksum too and report an error if they
>> don't match.  When writing the block, calculate and write the checksum too.
>>
>> This is already done by the disk drive - I'm not sure what you hope to gain
>> by doing it in the RAID layer as well.
>
> Consider RAID1/RAID10/RAID5/RAID6, where one or more members are returning bad
> data for some reason (e.g. are failing or have written garbage to disk during
> a sudden power loss). Having per-block checksums would allow to determine
> which members have correct data and which do not, and would help the RAID
> layer recover from that situation in the smartest way possible (with absolutely
> no loss or corruption of the user data).

I wasn't specifically thinking about bad data from a power loss, but the 
more general case of something in the pathway causing bad bits to have 
been committed or read back from the storage.  I am after being able to 
detect bad reads (silent corruption) and bad writes (by flushing then 
reading recently written blocks to compare).

Suppose, for example, we have a RAID1, and we read block N.  As a sanity 
check on the data, we can compare the data read from one device to 
another.  This doesn't tell us if the data is correct, just whether or 
not the same data was returned.  So the RAID layer (nor the disks 
themselves) would return an error in the event of this data not matching 
a checksum.  So if we computed a simple checksum compared it to a stored 
checksum, we could likely detect corruption on read.

Similar to this would be computing/comparing the RAIDn (n>1) checksum on 
every read.  It would cost somewhat more processing power, but I believe 
that in most cases, the disk performance would be the rate limiting process.

It might make more sense to push some of this up to the file system 
layers (ala btrfs), but I am thinking that it would be nice to have some 
elements of this functionality in the RAID layers, that the upper level 
file systems can use as a service.

