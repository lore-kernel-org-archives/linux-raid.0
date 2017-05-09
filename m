From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: RAID creation resync behaviors
Date: Tue, 9 May 2017 14:39:23 -0400
Message-ID: <1fca5ff4-358a-e0cf-d1a4-fc33ecdcbd62@gmail.com>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
 <87inlhpgzu.fsf@notabene.neil.brown.name>
 <20170504020452.kcmjgxnk7zsx7kdx@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170504020452.kcmjgxnk7zsx7kdx@kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On 05/03/2017 10:04 PM, Shaohua Li wrote:
> On Thu, May 04, 2017 at 11:07:01AM +1000, Neil Brown wrote:
>> On Wed, May 03 2017, Shaohua Li wrote:
>>
>>> Hi,
>>>
>>> Currently we have different resync behaviors in array creation.
>>>
>>> - raid1: copy data from disk 0 to disk 1 (overwrite)
>>> - raid10: read both disks, compare and write if there is difference (compare-write)
>>> - raid4/5: read first n-1 disks, calculate parity and then write parity to the last disk (overwrite)
>>> - raid6: read all disks, calculate parity and compare, and write if there is difference (compare-write)
>>
>> The approach taken for raid1 and raid4/5 provides the fastest sync for
>> an array built on uninitialised spinning devices.
>> RAID6 could use the same approach but would involve more CPU and so
>> the original author of the RAID6 code (hpa) chose to go for the low-CPU
>> cost option.  I don't know if tests were done, or if they would still be
>> valid on new hardware.
>> The raid10 approach comes from "it is too hard to optimize in general
>> because different RAID10 layouts have different trade-offs, so just
>> take the easy way out."
> 
> ok, thanks for the explanation!
>>>
>>> Write whole disk is very unfriendly for SSD, because it reduces lifetime. And
>>> if user already does a trim before creation, the unncessary write could make
>>> SSD slower in the future. Could we prefer compare-write to overwrite if mdadm
>>> detects the disks are SSD? Surely sometimes compare-write is slower than
>>> overwrite, so maybe add new option in mdadm. An option to let mdadm trim SSD
>>> before creation sounds reasonable too.
>>
>> An option to ask mdadm to trim the data space and then --assume-clean
>> certainly sounds reasonable.
> 
> This doesn't work well. read returns 0 for trimmed data space in some SSDs, but
> not all. If not, we will have trouble.

/sys/block/<device>/queue/discard_zeroes_data

We could use this as an indicator for what to do.

Jes
