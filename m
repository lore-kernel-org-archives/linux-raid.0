From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Mon, 26 Sep 2011 12:53:32 +0200
Message-ID: <4E8059AC.4060703@yazzy.org>
References: <4E7EDE58.3000804@yazzy.org> <20110926074002.6399de56@notabene.brown> <4E7FA3E8.5010603@yazzy.org> <20110926081853.2819622b@notabene.brown> <4E804062.3020700@yazzy.org> <20110926193130.6377f5b9@notabene.brown>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110926193130.6377f5b9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/26/11 11:31 AM, NeilBrown wrote:
> On Mon, 26 Sep 2011 11:05:38 +0200 "Marcin M. Jessa"<lists@yazzy.org>  wrote:
>
>> On 9/26/11 12:18 AM, NeilBrown wrote:
>>
>>> Do you remember what filesystem you had on 'storage'?  Was it ext3 or ext4 or
>>> xfs or something else?
>>
>> You're giving me some hope here and then silence :)
>> Why did you ask about the file system? Should I run fsck on the LV ?
>>
>>
>>
>
> You already did run fsck on the LV.  It basically said that it didn't
> recognise the filesystem at all.
> I asked in case maybe it was XFS in which case a different tool would be
> required.
> But you said it was EXT4, so the fsck.ext2 which you used should have worked
> if anything would.
>
> It is certainly odd that the LVM info is all consistent, but the filesystem
> info has disappear.  It could be that you have the chunksize or device order
> wrong and so it is looking for the filesystem info at the wrong place.
>
> Nothing else I can suggest - sorry.

Would it be worth a shot to use parted, create msdos label and then make 
a partition with a ext file system on top of it and run fsck?



-- 

Marcin M. Jessa
