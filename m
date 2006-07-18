From: Brad Campbell <brad@wasp.net.au>
Subject: Re: trying to "brute-force" my RAID 5...
Date: Tue, 18 Jul 2006 12:30:24 +0400
Message-ID: <44BC9C20.8060605@wasp.net.au>
References: <44BAB76D.9070809@start.no>	 <17596.15323.451555.218541@cse.unsw.edu.au> <fd8d0180607180117u73aa0259i3cdfcf5580148bc3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180607180117u73aa0259i3cdfcf5580148bc3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid@vger.kernel.org, Sevrin Robstad <quackyo@start.no>
List-Id: linux-raid.ids

Francois Barre wrote:
>> What are you expecting fdisk to tell you?  fdisk lists partitions and
>> I suspect you didn't have any partitions on /dev/md0
>> More likely you want something like
>>    fsck -n -f /dev/md0
>>
>> and see which one produces the least noise.
> 
> Maybe a simple file -s /dev/md0 could do the trick, and would only
> produce output different from the mere "data" when the good
> configuration is found...
> 
More likely to produce an output whenever the 1st disk in the array is in the right place as it will 
just look at the 1st couple of sectors for the superblock.

I'd go with the fsck idea as it will try to inspect the rest of the filesystem also.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
