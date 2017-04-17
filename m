From: Liu Zhilong <zlliu@suse.com>
Subject: Re: [PATCH 1/4] mdadm/util:integrate stat operations into one utility
Date: Mon, 17 Apr 2017 15:08:59 +0800
Message-ID: <db0ed456-77cb-2188-24f7-a970a5a6be80@suse.com>
References: <20170401125145.14440-1-zlliu@suse.com>
 <20170401125145.14440-2-zlliu@suse.com> <wrfj8tneeu8k.fsf@gmail.com>
 <0f6a630a-c53a-090e-67c3-8132f6d7b08e@suse.com>
 <e41b85e9-53ff-5f94-f80d-02ebd4e36238@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e41b85e9-53ff-5f94-f80d-02ebd4e36238@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/14/2017 11:20 PM, Jes Sorensen wrote:
> On 04/14/2017 06:14 AM, Liu Zhilong wrote:
>>
>>
>> On 04/05/2017 11:42 PM, jes.sorensen@gmail.com wrote:
>>> Zhilong Liu <zlliu@suse.com> writes:
> [snip]
>>> For a function like this, lets name it better md_is_blkdev()
>>
>> How about return the devid after checking? Because always need the
>> stb.st_rdev to parse
>> the major and minor number. Although "util.c" has "devnm2devid" to
>> gather the devid via
>> to devnm, but it's convenient to return devid when check the blkdev with
>> absolute path.
>> would you mind the function like this?
>>
>> // returns dev-id when success, return 0 when failure
>> dev_t stat_md_is_blkdev(char *dev)
>> {
>>     struct stat stb;
>>
>>     if (stat(dev, &stb) != 0) {
>>         pr_err("stat failed for %s: %s\n", dev, strerror(errno));
>>         return 0;
>>     }
>>     if ((S_IFMT & stb.st_mode) != S_IFBLK) {
>>         pr_err("%s is not a block device.\n", dev);
>>         return 0;
>>     }
>>     return stb.st_rdev;
>> }
>
> I am generally wary of too many smart handlers, but I think it makes 
> some sense here to de-duplicate the repeated code.
>
> That said, your function would ditch the error information, and the 
> caller wouldn't know why it failed. If you made it more like this and 
> return the error code, plus stick the major/minor number into rdev, if 
> one is provided:
>
> int stat_md_is_blkdev(char *devname, *dev_t rdev)
> {
> }
>

I want to integrate two situations into one function.
1. only check the 'dev'(such as /dev/loop2) whether or not is block device.
2. optionally return the rdev-id after checking the block device.
this sample "int stat_md_is_blkdev(char *devname, *dev_t rdev)" is smart 
for the situation 2. but for situation 1, the second parameter is a 
little waste.

how about like this?
dev_t stat_md_is_blkdev(char *devname, bool require_rdev)
{
     struct stat stb;

        if (stat(devname, &stb) != 0) {
                printf("stat failed for %s.\n", devname);
                return 1;
        }
        if ((S_IFMT & stb.st_mode) != S_IFBLK) {
                printf("%s is not a block device.\n", devname);
                return 1;
        }
        if (require_rdev)
           return stb.st_rdev;
     return 0;
}

the caller would be like this,
situation 1:
char dev[20] = "/dev/loop2";
if (stat_md_is_blkdev(dev, false))
   return 1;

situation 2:
dev_t st_rdev;
char dev[20] = "/dev/loop2";
st_rdev = stat_md_is_blkdev(dev, true);
if (st_rdev == 1)
   return 1;


Thanks very much,
-Zhilong

> Jes
>
>

