From: gary <gary.mdjiang@gmail.com>
Subject: Re: [PATCH 2/4] md-cluster: remove capabilities
Date: Wed, 15 Apr 2015 10:24:02 +0800
Message-ID: <552DCBC2.5040209@gmail.com>
References: <20150408192247.GA9682@shrek.lan> <552B2978.5000305@suse.com> <552CF96A.7000306@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <552CF96A.7000306@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, Guoqing Jiang <GQJiang@suse.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Goldwyn,
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index bc11551..0c65e51 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -2291,11 +2291,12 @@ static void export_rdev(struct md_rdev * rdev)
>>>       kobject_put(&rdev->kobj);
>>>   }
>>>
>>> -static void kick_rdev_from_array(struct md_rdev * rdev)
>>> +void md_kick_rdev_from_array(struct md_rdev * rdev)
>>>   {
>>>       unbind_rdev_from_array(rdev);
>>>       export_rdev(rdev);
>>>   }
>>> +EXPORT_SYMBOL_GPL(md_kick_rdev_from_array);
>>>
>>>   static void export_array(struct mddev *mddev)
>>>   {
>>> @@ -2306,7 +2307,7 @@ static void export_array(struct mddev *mddev)
>>>               MD_BUG();
>>>               continue;
>>>           }
>>> -        kick_rdev_from_array(rdev);
>>> +        md_kick_rdev_from_array(rdev);
>>>       }
>>>       if (!list_empty(&mddev->disks))
>>>           MD_BUG();
>>> @@ -2750,9 +2751,11 @@ state_store(struct md_rdev *rdev, const char 
>>> *buf, size_t len)
>>>               err = -EBUSY;
>>>           else {
>>>               struct mddev *mddev = rdev->mddev;
>>> -            if (mddev_is_clustered(mddev))
>>> +            if (mddev_is_clustered(mddev)) {
>>> md_cluster_ops->metadata_update_start(mddev);
>>> -            kick_rdev_from_array(rdev);
>>> +                md_cluster_ops->remove_disk(mddev, rdev);
>>> +            }
>>> +            md_kick_rdev_from_array(rdev);
>>>
>> For md-cluster, seems it is possible that md_kick_rdev_from_array could
>> be called twice,
>> is this what you want? Thanks.
>
>
> No, it would be called only once. There are two types of nodes in this 
> case: one is  sender and other received. The sender calls 
> md_kick_rdev_from_array() in the regular flow of 
> state_store/hot_remove_disk() while the receiver calls 
> md_kick_rdev_from_array() in the process_remove_disk().
>
Thanks for explanation, both sender node and receiver node need to kick
the disk from array. I misunderstood it, :(.

Regards,
Guoqing
