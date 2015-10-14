From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: First 12Mb of data missing after accidental deletion of first
 drive (4 2TB raid5)
Date: Wed, 14 Oct 2015 11:42:04 +1100
Message-ID: <561DA4DC.1080804@websitemanagers.com.au>
References: <CA+sqOsZSmYUDvwWu2MY-EpQyePGmT6wBjCCR5kKPEygKByD=Xw@mail.gmail.com>
 <CAETWcfvePZiUBiCY-cWMktQ=F7rckKt-7YDGa6PsiNt6j1ONGg@mail.gmail.com>
 <CA+sqOsaBm4jXrEpNyRMBoSMjE7f8MdAnq9Na3WcrLvVdAB7vSw@mail.gmail.com>
 <CAFE24U28NQBoKaTwNfXb5-3jK8PDggfZMUnc7KJLUGbrCFS-Xw@mail.gmail.com>
 <CA+sqOsZ2E-VyPikjX8mNFjgE3UkuHQ_84y58myHj4JN9UvQo-g@mail.gmail.com>
 <561D48F6.6010106@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <561D48F6.6010106@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>, Marek <mlf.conv@gmail.com>, Weedy <weedy2887@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Alexander Afonyashin <a.afonyashin@madnet-team.ru>
List-Id: linux-raid.ids

On 14/10/15 05:09, Benjamin ESTRABAUD wrote:
> Hi Marek,
>
> On 13/10/15 16:04, Marek wrote:
>> Could it be that the raid wasnt synced at the time i overwrote
>> /dev/sda ? i have run the command you suggested and will report after
>> its done. would it still be possible to recover the raid?
>>
> So what likely happened is that you wrote ontop of a RAID member drive 
> while the RAID was likely not assembled (during your install).
>
> If you do a resync it won't unfortunately *recover* the previously 
> written data, it will go over each stripe and recalculate the parity. 
> It is true that it *might* have been possible to do the opposite 
> operation by not touching anything and figuring out the previous data 
> with the data and parity blocks from the remaining RAID members 
> (assuming they weren't overwritten), but it would have been a tricky 
> operation. However, since you've done the resync now, the previous 
> parity blocks have been overwritten leaving you with a consistent 
> RAID, but with part of the data on a disk that you want to revert.
>
Or better action would be to stop the array, start the array excluding 
sda (not sure best way to manually mark it failed, or maybe physically 
remove it, or zero superblock should work too). Then you should have 
clean degraded array with all data. Now you could add sda back, and it 
will re-write correct data. (Assuming no writes were done to sdb/sdc/sdd).

Depending on what you actually did, and what order, it might still work....

Regards,
Adam

> At this stage you should recover the old data from a backup.
>
>> On Tue, Oct 13, 2015 at 4:36 PM, Weedy <weedy2887@gmail.com> wrote:
>>>
>>> On 13 Oct 2015 10:06 am, "Marek" <mlf.conv@gmail.com> wrote:
>>>>
>>>> no, i had a working raid consisting of 4 2TB drives (raid5)
>>>> sda,sdb,sdc,sdb ( no partitions were created on drives) - then i
>>>> accidentally deleted /dev/sda by installing ubuntu. when inspecting
>>>> dev/md127 with a hex editor i discovered first 12mb are missing.
>>>
>>> Wait, if it's a raid5 can't you just resync it?
>>>
>>> Also I believe 1.2 metadata is at the end of a partition. If your 
>>> saying the
>>> raids hasn't noticed you can run a check and it should fix itself.
>>>
>>> echo check > /sys/block/mdX/md/sync_action
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
