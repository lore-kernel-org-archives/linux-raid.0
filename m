From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Tue, 05 Nov 2013 22:36:44 +1100
Message-ID: <5278D84C.4040600@websitemanagers.com.au>
References: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com> <5278C2A6.7060005@websitemanagers.com.au> <E9509E1D-C8FB-4496-ADD5-C6ACBEFC4007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E9509E1D-C8FB-4496-ADD5-C6ACBEFC4007@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/11/13 21:37, Ivan Lezhnjov IV wrote:
> These are brand-new drives, that had fully synced some 20 hours before the array broke this morning, no problems with SMART stats or in OS logs. So, I'm fairly confident that the drives are OK.
> 
> Thanks for the detailed reply. I'm going to read a man page for all those arguments.  Meanwhile, I'm wondering if there's still a chance to assemble the array without a complete resync? It would take some 30 hrs with these drives and I'd rather avoid that, besides event count difference seems very small and I can see a lot of people say it is safe to add a non-fresh drive back in that case?
> 
> Could somebody please comment on this?

Personally, I'd prefer to know that the data is correct. It's not like
you actually need to work for those 30 hours, the computer will sync
them for you.

The problem is if you ignore the different contents, for those small
sections of disk (which are sections which were actually written to
recently with live data) you will get different content depending on
which disk you read, up until that section is re-written. The
alternative is to force the array, then run a check, and then a repair.
This will at least allow you to get consistent data regardless of which
disk you read from, however, you won't determine whether it is the
"newer" or "older" data (md will choose at random AFAIK).

Of course, a check will probably take close to 30 hours anyway, so why
not just do it properly, ensure you will get consistent data on both
disks, and that it is the most recent version/up to date.

Finally, while it might be safe to force the event count, it is usually
followed with:
run an fsck
get your data off the array as quickly as possible
rebuild the array

ie, most people are doing this with RAID5/6/10 arrays, and just want to
recover their data. I'm not sure it is suggested to continue to use the
array as normal.

Finally, once you add the bitmap, you will avoid the 30 hour resync in
future, you run all the same commands, but md will magically only sync
the needed sections which might only take a few minutes (yet still
ensure the entire disks are totally in sync, and use the freshest
version of data).

Regards,
Adam

> On Nov 5, 2013, at 12:04 PM, Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:
> 
>> Personally, I'd probably do something like:
>> mdadm --assemble /dev/md0 /dev/sdd1
>> mdadm --manage /dev/md0 --run
>> mdadm --manage /dev/md0 --add /dev/sdc1
>>
>> This will cause a full sync from sdd1 to sdc1, which will then ensure
>> both copies are identical/up to date.
>>
>> Personally, I would also do:
>> mdadm --grow /dev/md0 --bitmap=internal
>> This means next time you have a similar issue, when you add the older
>> drive, it will only sync the small parts of the drive that are out of
>> date, instead of the entire drive.
>>
>> Note: The above assumes that both drives are fully functional. If you
>> get a read error on sdd1 during the resync, then you will have
>> additional problems.
>>
>> Regards,
>> Adam
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
