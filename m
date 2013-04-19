From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] MD: Quickly return errors if too many devices have failed.
Date: Fri, 19 Apr 2013 08:22:39 -0500
Message-ID: <3C0B8390-710A-4F42-934D-4BEB3D4678CD@redhat.com>
References: <1363195764.24906.14.camel@f16> <20130318104905.4a70bc00@notabene.brown> <1C64DEE2-FCED-4B9A-A134-E03EA898A8B7@redhat.com> <20130320134611.4c9b0e75@notabene.brown> <AE87208C-5B7F-4949-8A99-F8841ADD5B1F@redhat.com> <20130321100450.6b82dbfa@notabene.brown> <6F836B18-FF2D-4CFC-BC1B-5F4F6313DF06@redhat.com> <20130328111327.0e64cdc6@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130328111327.0e64cdc6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids


On Mar 27, 2013, at 7:13 PM, NeilBrown wrote:

> On Thu, 21 Mar 2013 08:58:54 -0500 Brassow Jonathan <jbrassow@redhat.com>
> wrote:
> 
>> 
>> On Mar 20, 2013, at 6:04 PM, NeilBrown wrote:
>> 
>>> On Wed, 20 Mar 2013 15:56:03 -0500 Brassow Jonathan <jbrassow@redhat.com>
>>> wrote:
>>> 
>>>> 
>>>> On Mar 19, 2013, at 9:46 PM, NeilBrown wrote:
>>>> 
>>>>> On Tue, 19 Mar 2013 16:15:35 -0500 Brassow Jonathan <jbrassow@redhat.com>
>>>>> wrote:
>>>>> 
>>>>>> 
>>>>>> On Mar 17, 2013, at 6:49 PM, NeilBrown wrote:
>>>>>> 
>>>>>>> On Wed, 13 Mar 2013 12:29:24 -0500 Jonathan Brassow <jbrassow@redhat.com>
>>>>>>> wrote:
>>>>>>> 
>>>>>>>> Neil,
>>>>>>>> 
>>>>>>>> I've noticed that when too many devices fail in a RAID arrary that
>>>>>>>> addtional I/O will hang, yielding an endless supply of:
>>>>>>>> Mar 12 11:52:53 bp-01 kernel: Buffer I/O error on device md1, logical block 3
>>>>>>>> Mar 12 11:52:53 bp-01 kernel: lost page write due to I/O error on md1
>>>>>>>> Mar 12 11:52:53 bp-01 kernel: sector=800 i=3           (null)           (null)  
>>>>>>>>      (null)           (null) 1
>>>>>>> 
>>>>>>> This is the third report in as many weeks that mentions that WARN_ON.
>>>>>>> The first two where quite different causes.
>>>>>>> I think this one is the same as the first one, which means it would be fixed
>>>>>>> by  
>>>>>>>   md/raid5: schedule_construction should abort if nothing to do.
>>>>>>> 
>>>>>>> which is commit 29d90fa2adbdd9f in linux-next.
>>>>>> 
>>>>>> Sorry, I don't see this commit in linux-next:
>>>>>> (the "for-next" branch of) git://github.com/neilbrown/linux.git
>>>>>> or git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>>>>>> 
>>>>>> Where should I be looking?
>>>>> 
>>>>> Sorry, I probably messed up.
>>>>> I meant this commit:
>>>>> http://git.neil.brown.name/?p=md.git;a=commitdiff;h=ce7d363aaf1e28be8406a2976220944ca487e8ca
>>>> 
>>>> Yes, I found this patch in 'for-next'.  I tested 3.9.0-rc3 with and without this patch.  The good news is that my issue with RAID5 appears to be fixed with this patch.  To test, I simply created a 1GB RAID array, let it sync, killed all of the devices and then issued a 40M write request (4M block size).  Before the patch, I would see the kernel warnings and it would take 7+ minutes to finish the 40M write.  After the patch, I don't see the kernel warnings or call traces and it takes < 1 sec to finish the 40M write.  That's good.  Will this patch make it back to 3.[78]?
>>>> 
>>>> However, I also found that RAID1 can take 2.5 min to perform the write and RAID10 can take 9+ min.  Hung task messages with call traces and many many errors are the result.  This is bad.  I haven't figured out why these are so slow yet.
>>> 
>>> What happens if you take RAID out of the picture?
>>> i.e. write to a single device, then "kill" that device, then try issuing a
>>> 40M write request to it.
>>> 
>>> If that takes 2.5 minutes to resolve, then I think it is correct for RAID1 to
>>> also take 2.5 minutes to resolve. 
>>> If it resolves much more quickly than it does with RAID1, then that is a
>>> problem we should certainly address.
>> 
>> The test is a little different because once you offline a device, you can't open it.  So, I had to start I/O and then kill the device.  I still get 158MB/s - 3 orders of magnitude faster than RAID1.  Besides, if RAID10 takes 9+ minutes to complete, we'd still have something to fix.  I have also tested this with an "error" device and it also returns in sub-second time.
>> 
>> brassow
>> 
>> [root@bp-01 ~]# off.sh sda
>> Turning off sda
>> [root@bp-01 ~]# dd if=/dev/zero of=/dev/sda1 bs=4M count=10
>> dd: opening `/dev/sda1': No such device or address
>> [root@bp-01 ~]# on.sh sda
>> Turning on sda
>> [root@bp-01 ~]# dd if=/dev/zero of=/dev/sda bs=4M count=1000 &
>> [1] 5203
>> [root@bp-01 ~]# off.sh sda
>> Turning off sda
>> [root@bp-01 ~]# 1000+0 records in
>> 1000+0 records out
>> 4194304000 bytes (4.2 GB) copied, 26.5564 s, 158 MB/s
>> 
> 
> Maybe if you could show me some/all of the error messages that you get during
> these long delays it might help.  Also the error messages you (presumably)
> got from the kernel from the above plain-disk test.
> 
> It should quickly fail all but one copy of the data, then try writing to that
> copy exactly the same way that it would write to a plain disk.
> 
> For RAID10 large writes have to be chopped up for striping, so the extra
> requests which all have to fail could be the reason for the extra delay with
> RAID10.

Found the problem.  dm-raid does not support badblock tracking.  dm-raid was not setting badblocks.shift = -1.  Thus, RAID1/10 were trying to do narrow_write_error().  I'll have a patch for that shortly.

 brassow


