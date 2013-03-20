From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] MD: Quickly return errors if too many devices have failed.
Date: Wed, 20 Mar 2013 15:56:03 -0500
Message-ID: <AE87208C-5B7F-4949-8A99-F8841ADD5B1F@redhat.com>
References: <1363195764.24906.14.camel@f16> <20130318104905.4a70bc00@notabene.brown> <1C64DEE2-FCED-4B9A-A134-E03EA898A8B7@redhat.com> <20130320134611.4c9b0e75@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130320134611.4c9b0e75@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Jonathan Brassow <jbrassow@redhat.com>
List-Id: linux-raid.ids


On Mar 19, 2013, at 9:46 PM, NeilBrown wrote:

> On Tue, 19 Mar 2013 16:15:35 -0500 Brassow Jonathan <jbrassow@redhat.com>
> wrote:
> 
>> 
>> On Mar 17, 2013, at 6:49 PM, NeilBrown wrote:
>> 
>>> On Wed, 13 Mar 2013 12:29:24 -0500 Jonathan Brassow <jbrassow@redhat.com>
>>> wrote:
>>> 
>>>> Neil,
>>>> 
>>>> I've noticed that when too many devices fail in a RAID arrary that
>>>> addtional I/O will hang, yielding an endless supply of:
>>>> Mar 12 11:52:53 bp-01 kernel: Buffer I/O error on device md1, logical block 3
>>>> Mar 12 11:52:53 bp-01 kernel: lost page write due to I/O error on md1
>>>> Mar 12 11:52:53 bp-01 kernel: sector=800 i=3           (null)           (null)  
>>>>        (null)           (null) 1
>>> 
>>> This is the third report in as many weeks that mentions that WARN_ON.
>>> The first two where quite different causes.
>>> I think this one is the same as the first one, which means it would be fixed
>>> by  
>>>     md/raid5: schedule_construction should abort if nothing to do.
>>> 
>>> which is commit 29d90fa2adbdd9f in linux-next.
>> 
>> Sorry, I don't see this commit in linux-next:
>> (the "for-next" branch of) git://github.com/neilbrown/linux.git
>> or git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>> 
>> Where should I be looking?
> 
> Sorry, I probably messed up.
> I meant this commit:
> http://git.neil.brown.name/?p=md.git;a=commitdiff;h=ce7d363aaf1e28be8406a2976220944ca487e8ca

Yes, I found this patch in 'for-next'.  I tested 3.9.0-rc3 with and without this patch.  The good news is that my issue with RAID5 appears to be fixed with this patch.  To test, I simply created a 1GB RAID array, let it sync, killed all of the devices and then issued a 40M write request (4M block size).  Before the patch, I would see the kernel warnings and it would take 7+ minutes to finish the 40M write.  After the patch, I don't see the kernel warnings or call traces and it takes < 1 sec to finish the 40M write.  That's good.  Will this patch make it back to 3.[78]?

However, I also found that RAID1 can take 2.5 min to perform the write and RAID10 can take 9+ min.  Hung task messages with call traces and many many errors are the result.  This is bad.  I haven't figured out why these are so slow yet.

On a different topic, I've noticed the following commits in 'for-next':
  90584fc MD: Prevent sysfs operations on uninitialized kobjects
  e3620a3 MD RAID5: Avoid accessing gendisk or queue structs when not available
but these are not in 3.9.0-rc3.  They should make their way into 3.9.0 as well as 3.8.0.  (They apply cleanly to the 3.8 kernel, but I hadn't bothered to notify 'stable' - only mention the regression was introduced in 3.8-rc1.)

Thanks,
 brassow

