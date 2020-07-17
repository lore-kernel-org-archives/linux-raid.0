From: "heming.zhao@suse.com" <heming.zhao@suse.com>
Subject: Re: [PATCH v2] md-cluster: fix safemode_delay value when converting
 to clustered bitmap
Date: Fri, 17 Jul 2020 11:56:15 +0800
Message-ID: <f1e24754-d221-4ef2-8b2f-42cfcdca51f6@suse.com>
References: <1594911043-16956-1-git-send-email-heming.zhao@suse.com>
 <87wo33vxqo.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wo33vxqo.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neil@brown.name>, linux-raid@vger.kernel.org
Cc: neilb@suse.com, song@kernel.org
List-Id: linux-raid.ids


On 7/17/20 7:36 AM, NeilBrown wrote:
> On Thu, Jul 16 2020, Zhao Heming wrote:
> 
>> When array convert to clustered bitmap, the safe_mode_delay doesn't clean and vice versa.
>> the /sys/block/mdX/md/safe_mode_delay keep original value after changing bitmap type.
... ...
>>   			}
>>   			mddev_suspend(mddev);
>>   			md_bitmap_destroy(mddev);
>> @@ -8366,6 +8369,7 @@ int md_setup_cluster(struct mddev *mddev, int nodes)
>>   	}
>>   	spin_unlock(&pers_lock);
>>   
>> +	mddev->safemode_delay = 0;
>>   	return md_cluster_ops->join(mddev, nodes);
> 
> ->join can fail.
> I'd rather you checked the error there, and only clear safemode_delay if
> the return value is zero.
> 
> NeilBrown
> 
accept, I was aware of this issue after I sent the patch.
the md_cluster_stop() looks a good place to do the clear job.
md_bitmap_read_sb will call md_cluster_stop when md_setup_cluster return error.
I will send patch v3 after I finish test.

btw,
with investigation safemode_delay bug, I found there is another bug with cluster-md:
md_cluster module can't rmmod in some condition.

below test using original SUSE leap15.2 kernel (5.3.18-xx)
```
node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
mdadm: array /dev/md0 started.
node1 # lsmod | egrep  "raid|md_"
md_cluster             28672  1
raid1                  53248  1
md_mod                176128  2 raid1,md_cluster
dlm                   212992  14 md_cluster
node1 # mdadm -S --scan
node1 # lsmod | egrep  "raid|md_"
md_cluster             28672  0
raid1                  53248  0
md_mod                176128  2 raid1,md_cluster
dlm                   212992  9 md_cluster       <=== looks cluster-md holds sth, but md_cluster can rmmod now.

node1 # mdadm --zero-superblock /dev/sd{a,b}
node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
node1 # mdadm -G /dev/md0 -b none
node1 # lsmod | egrep  "raid|md_"
md_cluster             28672  1
raid1                  53248  1
md_mod                176128  2 raid1,md_cluster
dlm                   212992  9 md_cluster
node1 # mdadm -S --scan
node1 # lsmod | egrep  "raid|md_"
md_cluster             28672  1   <=== something still live
raid1                  53248  0
md_mod                176128  2 raid1,md_cluster
dlm                   212992  9 md_cluster
```

I plan to fix this rmmod bug after I fixing mdadm show active issue.
> 
>>   }
>>   
>> -- 
>> 1.8.3.1
