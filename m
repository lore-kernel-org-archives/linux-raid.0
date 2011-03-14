From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: More ddf container woes
Date: Mon, 14 Mar 2011 10:00:17 +0100
Message-ID: <4D7DD921.2060806@gmail.com>
References: <4D5FA5C4.8030803@gmail.com>	<4D63688E.5030501@gmail.com>	<20110223171712.09509f9e@notabene.brown>	<4D67ECA2.2020201@gmail.com>	<20110303093136.586df7e7@notabene.brown>	<4D788D2D.80706@gmail.com>	<4D7A0C78.2080402@gmail.com> <20110314190252.16d50cc2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110314190252.16d50cc2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  Hi Neil,

thanks, yes I noticed with the new git stuff some problems are fixed now.

I noticed one more thing:

When I look at the end of the output of the "mdadm -E /dev/md127" output I
see it mentions the amount of phyiscal disks. When I fail a disk it is 
marked as
"active/Offline, Failed" which is good. When I remove it, the amount of 
physical
disks reported by the "mdadm -E" command stays the same, the RefNo is still
there, the Size is still there, the Device file is removed and the state 
is still
"active/Offline, Failed". The whole entry should be removed and the 
amount of
physical disks lowered by one.

When I re-add the failed disk (but NOT zeroed the superblock) the state 
is still
"active/Offline, Failed" but reused for resynching a failed RAID set.

Assuming that the failed state of a disk is also recorded in the 
superblock on the disk
three different possibilities are likely when adding a disk:

- A clean new disk, a new superblock is created with a new RefNo
- A failed disk is added, use the failed state and RefNo
- A good disk is added, possibly from a good RAID set, use this 
superblock with the
RefNo and status. Make it possible to reassemble the RAID set when all 
the disks
are added.

Thanks for the fixes so far,

regards,

Albert

On 03/14/11 09:02 AM, NeilBrown wrote:
> On Fri, 11 Mar 2011 12:50:16 +0100 Albert Pauw<albert.pauw@gmail.com>  wrote:
>
>>    More experiments with the same setup
>>
> Hi Albert,
>   thanks again for this testing.
>
>> To sum it up, there are two problems here:
>>
>> - A failed disk in a subarray isn't automatically removed and marked
>> "Failed" in the container, although in some cases it does (see above).
>> Only after a manual "mdmon --all" will this take place.
> I think this is fixed in my devel-3.2 branch
>
>     git://neil.brown.name/mdadm devel-3.2
>
> Some aspects of it a fixed in the 'master' branch, but removing a
> device properly from a container won't be fixed in 3.1.x, only 3.2.x
>
>> - When two subarrays have failed disks, are degraded, but operational
>> and I add a spare disk to the container, both will pick up the spare
>> disk for replacement. They won't do this in parallel, but in sequence,
>> but nevertheless use the same disk.
> I haven't fixed this yet, but can easily duplicate it.  There are a
> couple of issues here that I need to think through before I get
> it fixed properly.
>
> Hopefully tomorrow.
>
> Thanks,
> NeilBrown
>
>
>> Albert
>>
>

