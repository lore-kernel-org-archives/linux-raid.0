From: Zhilong Liu <zlliu@suse.com>
Subject: Re: mdadm: one question about the readonly and readwrite feature
Date: Thu, 23 Mar 2017 11:54:59 +0800
Message-ID: <fbae7d86-db57-1c4d-efed-16ce0429332b@suse.com>
References: <774691e9-6b1e-5141-bc37-6e768c1c8fdc@suse.com>
 <87zigdt1r1.fsf@notabene.neil.brown.name> <58D32AE2.1030303@suse.com>
 <871stobqvl.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871stobqvl.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Guoqing Jiang <gqjiang@suse.com>, Jes Sorensen <jes.sorensen@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On 03/23/2017 11:42 AM, NeilBrown wrote:
> On Thu, Mar 23 2017, Guoqing Jiang wrote:
>
>> On 03/23/2017 05:55 AM, NeilBrown wrote:
>>> On Wed, Mar 22 2017, Zhilong Liu wrote:
>>>
>>>> Hi, Neil;
>>>>
>>>>      Excuse me, according to read 'mdadm/tests/ToTest', I'm a little
>>>> confused about "readonly"
>>>> and "readwrite" feature, and I've no idea how to fix it. Thus I report
>>>> this question and I'm sorry
>>>> for this long description email.
>>>>
>>>> relevant linux/driver/md commit: 260fa034ef7a4ff8b73068b48ac497edd5217491
>>>>
>>>>      My question: If the array has been set the MD_CLOSING flag, although
>>>> hasn't removed the sysfs
>>>> folder because sysfs_remove_group() wasn't invoked, and now, how should
>>>> mdadm continue to
>>>> control this 'readonly' array?
>>> MD_CLOSING should only be set for a short period or time to avoid
>>> certain races.  After the operation that set it completes, it should be
>>> cleared.
>>> It looks like this is a bug that was introduced in
>>> Commit: af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag")
>>> when MD_STILL_CLOSED was renamed to MD_CLOSING.
>> I guess it is because we set MD_CLOSING for STOP_ARRAY_RO cmd, then commit
>> af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag") did below changes:
>>
>> @@ -7075,9 +7073,13 @@ static int md_open(struct block_device *bdev,
>> fmode_t mode)
>>           if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
>>                   goto out;
>>
>> +       if (test_bit(MD_CLOSING, &mddev->flags)) {
>> +               mutex_unlock(&mddev->open_mutex);
>> +               return -ENODEV;
>> +       }
>>
>> Maybe we need to differentiate "STOP_ARRAY" and "STOP_ARRAY_RO", or
>> revert above
>> changes.
>>
> No, your missing the point.
> What you describe above would change the effect of what MD_CLOSING does.
> We don't want to change it.  It is good.
> The problem is that when it has finished doing what it needs to do,
> we aren't clearing it. That is simply a bug.
>
> So something like this is needed.

I can understand this method, :-). So I would do further learning on 
this code path.
I would response on it later. Thanks very much.

Thanks,
-Zhilong
> NeilBrown
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 7e168ff1ae90..567aba246497 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6934,6 +6934,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
>   	void __user *argp = (void __user *)arg;
>   	struct mddev *mddev = NULL;
>   	int ro;
> +	bool did_set_md_closing = false;
>   
>   	if (!md_ioctl_valid(cmd))
>   		return -ENOTTY;
> @@ -7023,7 +7024,9 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
>   			err = -EBUSY;
>   			goto out;
>   		}
> +		WARN_ON_ONCE(test_bit(MD_CLOSING, &mddev->flags));
>   		set_bit(MD_CLOSING, &mddev->flags);
> +		did_set_md_closing = true;
>   		mutex_unlock(&mddev->open_mutex);
>   		sync_blockdev(bdev);
>   	}
> @@ -7216,6 +7219,8 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
>   		mddev->hold_active = 0;
>   	mddev_unlock(mddev);
>   out:
> +	if (did_set_md_closing)
> +		clear_bit(MD_CLOSING, &mddev->flags);
>   	return err;
>   }
>   #ifdef CONFIG_COMPAT

