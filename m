From: Phil Turmel <philip@turmel.org>
Subject: Re: Wiki, raid 10, and my new system :-)
Date: Tue, 17 Oct 2017 15:04:09 -0400
Message-ID: <6c901544-fe5e-fd6a-b3b3-6b8e5edfa36b@turmel.org>
References: <59E4BA29.4050907@youngman.org.uk>
 <e3ee3a5d-a6b0-49aa-1949-18a248e1397f@thelounge.net>
 <87y3oak3zj.fsf@notabene.neil.brown.name>
 <67a81e49-37b6-b0f7-f9e2-16301ecd4f9a@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <67a81e49-37b6-b0f7-f9e2-16301ecd4f9a@youngman.org.uk>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/17/2017 02:32 PM, Anthony Youngman wrote:
> On 17/10/17 01:33, NeilBrown wrote:

>> This patch has some good stuff, but
>>
>>    Chunk Size, as per the Linux RAID wiki, is the smallest unit of data
>>    that can be written to the devices
>>
>> I wonder where the Linux RAID wiki say that.  It is wrong.
>> The smallest unit of data that can be written to the devices is the
>> block size, which is hardware dependant and typically 512bytes or 4K.
>> This is not the same as the chunk size.
>>
> https://raid.wiki.kernel.org/index.php/RAID_setup#Chunk_sizes
> 
> I understand what it's saying - this is the smallest size passed down to
> the disk, not the smallest size that the disk can write ... :-)
> 
> This page has made it into the archaeology section so I don't plan to
> update it. And in context, it's reasonably clear what it means.

No, it is *wrong*.  Writes in multiples of 4k and entirely within a
chunk are passes as-is to the devices.  For mirrors, all affected
devices get a copy of the request.  For parity raid, the 4k stripes
corresponding to those 4k blocks will be pulled into the stripe cache
for recalculation.  Not whole chunk-size stripes.  The stripe cache is
multiples of 4k, not multiples of the chunk size!

Writes smaller than 4k, or not aligned to 4k, will generate a
read-modify-write cycle of the 4k block involved.  Not the whole chunk.

It is more accurate to say that a chunk may be the *largest* a request
can be before it is split between devices.

Phil
