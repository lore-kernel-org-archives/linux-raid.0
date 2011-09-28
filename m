From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Tue, 27 Sep 2011 21:50:58 -0500
Message-ID: <4E828B92.40502@hardwarefreak.com>
References: <4E7EDE58.3000804@yazzy.org> <20110926074002.6399de56@notabene.brown> <4E7FA3E8.5010603@yazzy.org> <20110926081853.2819622b@notabene.brown> <4E804062.3020700@yazzy.org> <20110926193130.6377f5b9@notabene.brown> <4E82203A.60507@yazzy.org> <20110928091335.1df35f8e@notabene.brown>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110928091335.1df35f8e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: lists@yazzy.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/27/2011 6:13 PM, NeilBrown wrote:
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
> NeilBrown

Reading the thread, and the many like it over the past months/years, may 
yield a clue as to why you wish to move on to something other than Linux 
RAID...

-- 
Stan


