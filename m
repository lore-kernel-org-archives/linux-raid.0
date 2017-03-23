From: Zhilong Liu <zlliu@suse.com>
Subject: Re: mdadm: one question about the readonly and readwrite feature
Date: Thu, 23 Mar 2017 16:14:56 +0800
Message-ID: <8aabda0c-023f-6033-26d1-c6a6c907b8e6@suse.com>
References: <774691e9-6b1e-5141-bc37-6e768c1c8fdc@suse.com>
 <87zigdt1r1.fsf@notabene.neil.brown.name> <58D32AE2.1030303@suse.com>
 <871stobqvl.fsf@notabene.neil.brown.name>
 <600b22b5-762e-da9c-0d20-9023de4361b3@suse.com>
 <87poh8a2vz.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87poh8a2vz.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Guoqing Jiang <gqjiang@suse.com>, Jes Sorensen <jes.sorensen@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On 03/23/2017 03:06 PM, NeilBrown wrote:
> On Thu, Mar 23 2017, Zhilong Liu wrote:
>
>> On 03/23/2017 11:42 AM, NeilBrown wrote:
>>> On Thu, Mar 23 2017, Guoqing Jiang wrote:
>>>
>>>> On 03/23/2017 05:55 AM, NeilBrown wrote:
>>>>> On Wed, Mar 22 2017, Zhilong Liu wrote:
>>>>>
>>>>>> Hi, Neil;
>>>>>>
>>>>>>       Excuse me, according to read 'mdadm/tests/ToTest', I'm a little
>>>>>> confused about "readonly"
>>>>>> and "readwrite" feature, and I've no idea how to fix it. Thus I report
>>>>>> this question and I'm sorry
>>>>>> for this long description email.
>>>>>>
>>>>>> relevant linux/driver/md commit: 260fa034ef7a4ff8b73068b48ac497edd5217491
>>>>>>
>>>>>>       My question: If the array has been set the MD_CLOSING flag, although
>>>>>> hasn't removed the sysfs
>>>>>> folder because sysfs_remove_group() wasn't invoked, and now, how should
>>>>>> mdadm continue to
>>>>>> control this 'readonly' array?
>>>>> MD_CLOSING should only be set for a short period or time to avoid
>>>>> certain races.  After the operation that set it completes, it should be
>>>>> cleared.
>>>>> It looks like this is a bug that was introduced in
>>>>> Commit: af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag")
>>>>> when MD_STILL_CLOSED was renamed to MD_CLOSING.
>>>> I guess it is because we set MD_CLOSING for STOP_ARRAY_RO cmd, then commit
>>>> af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag") did below changes:
>>>>
>>>> @@ -7075,9 +7073,13 @@ static int md_open(struct block_device *bdev,
>>>> fmode_t mode)
>>>>            if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
>>>>                    goto out;
>>>>
>>>> +       if (test_bit(MD_CLOSING, &mddev->flags)) {
>>>> +               mutex_unlock(&mddev->open_mutex);
>>>> +               return -ENODEV;
>>>> +       }
>>>>
>>>> Maybe we need to differentiate "STOP_ARRAY" and "STOP_ARRAY_RO", or
>>>> revert above
>>>> changes.
>>>>
>>> No, your missing the point.
>>> What you describe above would change the effect of what MD_CLOSING does.
>>> We don't want to change it.  It is good.
>>> The problem is that when it has finished doing what it needs to do,
>>> we aren't clearing it. That is simply a bug.
>>>
>>> So something like this is needed.
>> Sorry again, I have another question in md_set_readonly() of md.c
>> Although it has stopped all md writes operations, and I still prefer
>> to do set_disk_ro after md_wakeup_thread. refer to following code.
> Why?
> How do the actions performed by set_disk_ro() interact with the actions
> performed by md_wakeup_thread()?
>
> I'm not saying the code shouldn't be changed, just that there needs to
> be a clear explanation of the benefit.

here just according to my understanding for readonly code path, welcome
the correction in my comments if I misunderstand this feature, :-).
... ...
static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
{
         int err = 0;
         int did_freeze = 0;

         if (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
                 did_freeze = 1;
                 set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);  --> 
here has set bit as FROZEN
                 md_wakeup_thread(mddev->thread);
         }
... ...

         if (mddev->pers) {
                 __md_stop_writes(mddev);
/*
  *  set FROZEN again, maybe can use test_and_set_bit(FROZEN) better, it 
doesn't matter.
  *  it flushed and synced all data, bitmap and superblock to array.
  */
                 err  = -ENXIO;
                 if (mddev->ro==1)
                         goto out;
                 mddev->ro = 1;
/*
  *  Here, I means that set_disk_ro until the daemon thread has 
completed all operations
  *  include of sync and recovery progress. set_disk_ro when the array 
has cleaned totally,
  *  then it would be safer.
  *  I'm not sure MD_RECOVERY_NEEDED would be running once the array has 
set_disk_ro,
  *  actually I don't know how to test this scenario, thus asked this 
question.
  */
                 set_disk_ro(mddev->gendisk, 1);
                 clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
                 set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
                 md_wakeup_thread(mddev->thread);
                 sysfs_notify_dirent_safe(mddev->sysfs_state);

Thanks very much,
-Zhilong
> NeilBrown
>
>
>> cut the piece of code:
>> ... ...
>> static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
>> {
>> ... ...
>>           if (mddev->pers) {
>>                   __md_stop_writes(mddev);
>>
>>                   err  = -ENXIO;
>>                   if (mddev->ro==1)
>>                           goto out;
>>                   mddev->ro = 1;
>>                   set_disk_ro(mddev->gendisk, 1);         ## --> I prefer
>> to do it after md_wakeup_thread.
>>                   clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>>                   set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>                   md_wakeup_thread(mddev->thread);     ## --> do
>> set_disk_ro after this step.
>>                   sysfs_notify_dirent_safe(mddev->sysfs_state);
>>                   err = 0;
>>           }
>> out:
>>           mutex_unlock(&mddev->open_mutex);
>>           return err;
>> }
>>
>> Thanks,
>> -Zhilong
>>> NeilBrown
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 7e168ff1ae90..567aba246497 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -6934,6 +6934,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
>>>    	void __user *argp = (void __user *)arg;
>>>    	struct mddev *mddev = NULL;
>>>    	int ro;
>>> +	bool did_set_md_closing = false;
>>>    
>>>    	if (!md_ioctl_valid(cmd))
>>>    		return -ENOTTY;
>>> @@ -7023,7 +7024,9 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
>>>    			err = -EBUSY;
>>>    			goto out;
>>>    		}
>>> +		WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
>>>    		set_bit(MD_CLOSING, &mddev->flags);
>>> +		did_set_md_closing = true;
>>>    		mutex_unlock(&mddev->open_mutex);
>>>    		sync_blockdev(bdev);
>>>    	}
>>> @@ -7216,6 +7219,8 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
>>>    		mddev->hold_active = 0;
>>>    	mddev_unlock(mddev);
>>>    out:
>>> +	if (did_set_md_closing)
>>> +		clear_bit(MD_CLOSING, &mddev->flags);
>>>    	return err;
>>>    }
>>>    #ifdef CONFIG_COMPAT

