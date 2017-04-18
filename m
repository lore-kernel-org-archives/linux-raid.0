From: Zhilong Liu <zlliu@suse.com>
Subject: Re: Zombie dm device?
Date: Tue, 18 Apr 2017 10:36:48 +0800
Message-ID: <ff1512f1-f499-43f9-daef-85cdaf1cb2ef@suse.com>
References: <3cf28b7e-9716-3595-018a-fecb32b61751@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3cf28b7e-9716-3595-018a-fecb32b61751@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Susi <psusi@ubuntu.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/18/2017 03:50 AM, Phil Susi wrote:
> After running the parted test suite I seem to have a zombie md device:
>
> root@devserv:~# mdadm -D /dev/md99
> /dev/md99:
>          Version :
>       Raid Level : raid0
>    Total Devices : 0
>
>            State : inactive
>
>      Number   Major   Minor   RaidDevice
>
>
> Why is this thing still hanging around, and how do you get rid of it?  I
> tried mdadm --stop /dev/md99 but it didn't get rid of it.  I also can't
> find any mdadm switch or a delete file or similar in the sysfs node.

can you find the /sys/block/md99/md/array_state? issue the
# echo clear > /sys/block/md99/md/array_state  to stop array.
The test suit is in improving progress, a few test cases cannot
work well currently. you can talk about your requirement, and
I would record it. more details, more appreciate. :-)

Thanks,
-Zhilong
> root@devserv:~# uname -a
> Linux devserv 4.4.0-72-generic #93-Ubuntu SMP Fri Mar 31 14:07:41 UTC
> 2017 x86_64 x86_64 x86_64 GNU/Linux
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

