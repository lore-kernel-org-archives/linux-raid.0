From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [PATCH] Monitor: don't assume mdadm parameter is a block device
Date: Tue, 20 Jun 2017 08:30:46 +0800
Message-ID: <066955AE-A004-4C33-8CB1-8DCAC4DA28E0@suse.com>
References: <1497621778-8967-1-git-send-email-tomasz.majchrzak@intel.com> <585FFF8D-0238-4AB3-AA77-4C3C00C3C55D@suse.com> <20170619091658.GA9305@proton.igk.intel.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=gb2312
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170619091658.GA9305@proton.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids



> 在 2017年6月19日，17:16，Tomasz Majchrzak <tomasz.majchrzak@intel.com> 写道：
> 
>> On Sun, Jun 18, 2017 at 10:10:02PM +0800, Zhilong Liu wrote:
>> 
>> 
>>> 在 2017年6月16日，22:02，Tomasz Majchrzak <tomasz.majchrzak@intel.com> 写道：
>>> 
>>> If symlink (e.g. /dev/md/raid) is passed as a parameter to mdadm --wait,
>>> it fails as it's not able to find a corresponding entry in /proc/mdstat
>>> output. Get parameter file major:minor and look for block device name in
>>> sysfs. This commit is partial revert of commit 9e04ac1c43e6
>>> ("mdadm/util: unify fstat checking blkdev into function").
>>> 
>> 
>> Thanks very much for catching this.  Just remind a typo in (commit title), correct fstat as stat.
> 
> Will do.
> 
>> 
>>> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
>>> ---
>>> Monitor.c | 13 +++++++++++--
>>> 1 file changed, 11 insertions(+), 2 deletions(-)
>>> 
>>> v2:
>>> next Zhilong Liu commit id
>>> 
>>> diff --git a/Monitor.c b/Monitor.c
>>> index bef2f1b..c9f24bd 100644
>>> --- a/Monitor.c
>>> +++ b/Monitor.c
>>> @@ -982,12 +982,21 @@ static void link_containers_with_subarrays(struct state *list)
>>> int Wait(char *dev)
>>> {
>>>   char devnm[32];
>>> +    dev_t rdev;
>>> +    char *tmp;
>>>   int rv = 1;
>>>   int frozen_remaining = 3;
>>> 
>>> -    if (!stat_is_blkdev(dev, NULL))
>>> +    if (!stat_is_blkdev(dev, &rdev))
>>> +        return 2;
>>> +
>>> +    tmp = devid2devnm(rdev);
>>> +    if (!tmp) {
>>> +        pr_err("Cannot get md device name.\n");
>>>       return 2;
>>> -    strcpy(devnm, dev);
>>> +    }
>>> +
>>> +    strcpy(devnm, tmp);
>>> 
>> 
>> Quite agreed with the code here, just a small question,  I may use 
>>> strcpy(devnm, devid2devnm(rdev));
>> directly since stat_is_blkdev() has returned the major/minor devid. I don't know "get md device name " would be failed in which scenario. 
>> I'm asking this question since I haven't been familiar with all raids situations. :-)
>> 
>> Thanks again,
>> Zhilong
> 
> Well, there could be a race and RAID array might get stopped between two
> calls (stat_is_blkdev, devid2devnm) so corresponding sysfs entry would not
> exist. Also I don't think we should assume devid2devnm implementation won't
> change one day. I just did it safe way, otherwise static code analyzers
> would complain.
> 

Thanks very much for the correction. :-)

Zhilong 


> Tomek
> 

