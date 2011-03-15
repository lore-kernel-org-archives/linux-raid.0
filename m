From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: More ddf container woes
Date: Tue, 15 Mar 2011 20:07:17 +0100
Message-ID: <4D7FB8E5.6020600@gmail.com>
References: <4D5FA5C4.8030803@gmail.com>	<4D63688E.5030501@gmail.com>	<20110223171712.09509f9e@notabene.brown>	<4D67ECA2.2020201@gmail.com>	<20110303093136.586df7e7@notabene.brown>	<4D788D2D.80706@gmail.com>	<4D7A0C78.2080402@gmail.com>	<20110314190252.16d50cc2@notabene.brown>	<4D7DD921.2060806@gmail.com> <20110315154325.2e50c4ad@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110315154325.2e50c4ad@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  Hi Neil,

I updated to the git version (devel) and tried my "old" tricks:

- Create a container with 5 disks
- Created two raid sets (raid 1 md0 and raid 5 md1) in this container

mdadm -E  /dev/md127 shows all disks active/Online

- Failed one disk in md0

mdadm -E /dev/md127 shows this disk as active/Offline, Failed

- Failed one disk in md1

mdadm -E /dev/md127 shows this disk as active/Offline, Failed

- Added a new spare disk to the container

mdadm -E /dev/md127 shows this new disk as active/Online, Rebuilding

this looks good, but although the container has six disks, the lastly failed
disk is missing, mdadm -E /dev/md127 only shows five disks (including 
the rebuilding one).

This time however, only one of the failed raid sets is rebuilding, so 
that fix is ok.

Here is another scenario with strange implications:

- Created a container with 6 disks

mdadm -E /dev/md127 shows all 6 disks as Global-Spare/Online

- Removed one of the disks, as I only needed 5

This time mdadm -e /dev/md127 shows six physical disks, one of which has 
no device

- Created two raid sets (raid 1 md0 and raid 5 md1) in this container

mdadm -E  /dev/md127 shows all disks active/Online, except the "empty 
entry" which stays
Global-Spare/Online

- I fail two disks, one in each raid array

mdadm -E /dev/md127 shows these two disks as active/Offline, Failed

- I add back the disk I removed earlier, it should fit into the empty 
slot of mdadm -E

mdadm -E /dev/md127 shows something very strange, namely
-> All disks are not set to Global-Spare/Online
-> All device files are removed from the slots in mdadm -E, except the 
newly added one,
which shows the correct device

Albert

On 03/15/11 05:43 AM, NeilBrown wrote:
> On Mon, 14 Mar 2011 10:00:17 +0100 Albert Pauw<albert.pauw@gmail.com>  wrote:
>
>>    Hi Neil,
>>
>> thanks, yes I noticed with the new git stuff some problems are fixed now.
>>
>> I noticed one more thing:
>>
>> When I look at the end of the output of the "mdadm -E /dev/md127" output I
>> see it mentions the amount of phyiscal disks. When I fail a disk it is
>> marked as
>> "active/Offline, Failed" which is good. When I remove it, the amount of
>> physical
>> disks reported by the "mdadm -E" command stays the same, the RefNo is still
>> there, the Size is still there, the Device file is removed and the state
>> is still
>> "active/Offline, Failed". The whole entry should be removed and the
>> amount ofen
>> physical disks lowered by one.
> Well... maybe.  Probably.
>
> The DDF spec "requires" that there be an entry in the "physical disks"
> table for every disk that is connected to the controller - whether failed
> or not.
> That makes some sense when you think about a hardware-RAID controller.
> But how does that apply when DDF is running on a host system rather than
> a RAID controller??
> Maybe we should only remove them when they are physically unplugged??
>
> There would probably be value in thinking through all of this a lot more
> but for now I have arranged to remove any failed device that it not
> part of an array (even a failed part).
>
> You can find all of this in my git tree.  I decided to back-port the
> code from devel-3.2 which deletes devices from the DDF when you remove
> them from a container - so you should find the code in the 'master'
> branch works as well as that in 'devel-3.2'.
>
> I would appreciate any more testing results that you come up with.
>
>
>
>> When I re-add the failed disk (but NOT zeroed the superblock) the state
>> is still
>> "active/Offline, Failed" but reused for resynching a failed RAID set.
>>
>> Assuming that the failed state of a disk is also recorded in the
>> superblock on the disk
>> three different possibilities are likely when adding a disk:
>>
>> - A clean new disk, a new superblock is created with a new RefNo
>> - A failed disk is added, use the failed state and RefNo
>> - A good disk is added, possibly from a good RAID set, use this
>> superblock with the
>> RefNo and status. Make it possible to reassemble the RAID set when all
>> the disks
>> are added.
> It currently seems to preserve the 'failed' state.  While that may
> not be ideal, it is not clearly 'wrong' and can be worked-around
> by zeroing the metadata.
>
> So I plan to leave it as it is for the moment.
>
> I hope to put a bit of time in to sorting out some of these more subtle
> issues next week - so you could well see progress in the future ...
> especially if you have a brilliant idea about how it *should* work and manage
> to convince me :-)
>
>
>
>> Thanks for the fixes so far,
> And thank you for your testing.
>
> NeilBrown
>

