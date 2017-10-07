From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [PATCH 1/3] mdadm/grow: Component size must be larger than chunk size
Date: Sat, 7 Oct 2017 20:17:55 +0800
Message-ID: <3677C02D-4005-4E30-B3C7-46EF8BED6C9A@suse.com>
References: <1504604498-26048-1-git-send-email-zlliu@suse.com> <1504604498-26048-2-git-send-email-zlliu@suse.com> <20171005114430.GA24654@proton.igk.intel.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=gb2312
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171005114430.GA24654@proton.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@gmail.com>
List-Id: linux-raid.ids



> 在 2017年10月5日，19:44，Tomasz Majchrzak <tomasz.majchrzak@intel.com> 写道：
> 
>> On Tue, Sep 05, 2017 at 05:41:36PM +0800, Zhilong Liu wrote:
>> Grow: Changing component size must be larger than current
>> chunk size against stripe raids, otherwise Grow_reshape()
>> would set s->size to '0'.
>> 
>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>> ---
>> Grow.c | 6 ++++++
>> 1 file changed, 6 insertions(+)
>> 
>> diff --git a/Grow.c b/Grow.c
>> index 534ba80..f0a21ff 100644
>> --- a/Grow.c
>> +++ b/Grow.c
>> @@ -1816,6 +1816,12 @@ int Grow_reshape(char *devname, int fd,
>>        return 1;
>>    }
>> 
>> +    if (array.level > 1 &&
>> +       (array.chunk_size / 1024) > (int)s->size) {
>> +        pr_err("component size must be larger than chunk size.\n");
>> +        return 1;
>> +    }
>> +
>>    st = super_by_fd(fd, &subarray);
>>    if (!st) {
>>        pr_err("Unable to determine metadata format for %s\n", devname);
>> -- 
>> 2.6.6
> 
> 
> Hi Zhilong Liu,
> 
> Above patch has broken RAID level conversion:
> 
> Before the patch:
> 
> mdadm --create /dev/md/raid --level=10 --raid-devices=4 /dev/nvme0n1
> /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 --run --assume-clean
> MDADM_EXPERIMENTAL=1 mdadm --grow /dev/md/raid --level=0
> mdadm: level of /dev/md/raid changed to raid0
> 
> After the patch:
> 
> mdadm --create /dev/md/raid --level=10 --raid-devices=4 /dev/nvme0n1
> /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 --run --assume-clean
> MDADM_EXPERIMENTAL=1 mdadm --grow /dev/md/raid --level=0
> mdadm: component size must be larger than chunk size.
> 
> Could you take a look at it, please?
> 

Hi, Tomek;
   Thanks for your information. I would verify it when I'm back from vacation.
  Yes, this condition should be proper only in create mode.

Thanks very much,
Zhilong

> Thanks,
> 
> Tomek
> 

