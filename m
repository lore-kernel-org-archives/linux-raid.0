From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Wiki, raid 10, and my new system :-)
Date: Tue, 17 Oct 2017 19:32:55 +0100
Message-ID: <67a81e49-37b6-b0f7-f9e2-16301ecd4f9a@youngman.org.uk>
References: <59E4BA29.4050907@youngman.org.uk>
 <e3ee3a5d-a6b0-49aa-1949-18a248e1397f@thelounge.net>
 <87y3oak3zj.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y3oak3zj.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/10/17 01:33, NeilBrown wrote:
> On Mon, Oct 16 2017, Reindl Harald wrote:
> 
>> Am 16.10.2017 um 15:54 schrieb Wols Lists:
>>> Raid 10 is a complicated subject what with near and far, and whether it
>>> will grow, etc etc.
>>>
>>> I'm planning to raid-10 my swap partition, and while it doesn't matter
>>> in the slightest because destroying and recreating will be no hassle for
>>> swap, I'd like to understand what's going on.
>>>
>>> If I remember correctly, there was a thread a little while back on
>>> growing a raid-10? And you can't (for certain values of "can't" :-) do it?
>>>
>>> Where's the best place to find info about near, far and offset layouts?
>>
>> http://xmodulo.com/setup-raid10-linux.html
> 
> This patch has some good stuff, but
> 
>    Chunk Size, as per the Linux RAID wiki, is the smallest unit of data
>    that can be written to the devices
> 
> I wonder where the Linux RAID wiki say that.  It is wrong.
> The smallest unit of data that can be written to the devices is the
> block size, which is hardware dependant and typically 512bytes or 4K.
> This is not the same as the chunk size.
> 
https://raid.wiki.kernel.org/index.php/RAID_setup#Chunk_sizes

I understand what it's saying - this is the smallest size passed down to 
the disk, not the smallest size that the disk can write ... :-)

This page has made it into the archaeology section so I don't plan to 
update it. And in context, it's reasonably clear what it means.

Cheers,
Wol
