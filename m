From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Fri, 30 Sep 2011 22:01:40 +0200
Message-ID: <4E862024.9090306@yazzy.org>
References: <4E7EDE58.3000804@yazzy.org> <20110926074002.6399de56@notabene.brown> <4E7FA3E8.5010603@yazzy.org> <20110926081853.2819622b@notabene.brown> <4E804062.3020700@yazzy.org> <20110926193130.6377f5b9@notabene.brown> <4E82203A.60507@yazzy.org> <20110928091335.1df35f8e@notabene.brown>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110928091335.1df35f8e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/28/11 1:13 AM, NeilBrown wrote:
> On Tue, 27 Sep 2011 21:12:58 +0200 "Marcin M. Jessa"<lists@yazzy.org>  wrote:
>
>> On 9/26/11 11:31 AM, NeilBrown wrote:
>>> On Mon, 26 Sep 2011 11:05:38 +0200 "Marcin M. Jessa"<lists@yazzy.org>   wrote:
>>>
>>>> On 9/26/11 12:18 AM, NeilBrown wrote:
>>>>
>>>>> Do you remember what filesystem you had on 'storage'?  Was it ext3 or ext4 or
>>>>> xfs or something else?
>>>>
>>>> You're giving me some hope here and then silence :)
>>>> Why did you ask about the file system? Should I run fsck on the LV ?
>>>>
>>>>
>>>>
>>>
>>> You already did run fsck on the LV.  It basically said that it didn't
>>> recognise the filesystem at all.
>>> I asked in case maybe it was XFS in which case a different tool would be
>>> required.
>>
>> Looks like I didn't remember correctly. I ran testdisk and it reported
>> the file system to be XFS. What would you suggest now Neil?
>>
>>
>
> Presumably
>     xfs_check /dev/fridge/storage
>
> and then maybe
>     xfs_repair /dev/fridge/storage
>
> but I have no experience with XFS - I'm just reading man pages.
>

That didn't work so I decided to give photorec a spin and so far it 
could find and recover lots of files [1].
Why the heck is photorec able to do so but the normal file system fixing 
tools are just useless?


[1]:
Disk /dev/dm-0 - 5368 GB / 5000 GiB (RO)
Partition Start End Size in sectors
No partition 0 10485759999 10485760000 [Whole disk]


Pass 2 - Reading sector 1506591634/10485760000, 843 files found
Elapsed time 10h16m59s - Estimated time for achievement 61h17m10
txt: 445 recovered
exe: 198 recovered
mpg: 62 recovered
swf: 33 recovered
tx?: 33 recovered
gif: 25 recovered
gpg: 19 recovered
bmp: 5 recovered
gz: 4 recovered
riff: 4 recovered
others: 15 recovered



-- 

Marcin M. Jessa
