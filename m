From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [mdadm PATCH 1/1] Fix a building error
Date: Tue, 19 Sep 2017 16:00:47 +0200
Message-ID: <fc80b1d8-af66-db54-ed18-1475a54e6467@molgen.mpg.de>
References: <1505816081-7887-1-git-send-email-xni@redhat.com>
 <059748ff-f5b9-bdf5-a4eb-ff1acbaa60c3@molgen.mpg.de>
 <815339809.11997756.1505827012878.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <815339809.11997756.1505827012878.JavaMail.zimbra@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: jsorensen@fb.com, zlliu@suse.com, linux-raid@vger.kernel.org, Nigel Croxon <ncroxon@redhat.com>
List-Id: linux-raid.ids

Dear Xiao,


On 09/19/17 15:16, Xiao Ni wrote:

> ----- Original Message -----
>> From: "Paul Menzel" <pmenzel@molgen.mpg.de>
>> To: "Xiao Ni" <xni@redhat.com>
>> Cc: jsorensen@fb.com, zlliu@suse.com, linux-raid@vger.kernel.org
>> Sent: Tuesday, September 19, 2017 6:24:52 PM

[…]

>> On 09/19/17 12:14, Xiao Ni wrote:
>>> In s390 platform, it gives a building error:
>>
>> s/building error/build error/
>>
>> Maybe: On s390 platform the build fails with the error below.
> 
> Ok.
>>
>>> Manage.c: In function 'Manage_subdevs':
>>> Manage.c:1502:5: error: passing argument 3 of 'fstat_is_blkdev' from
>>> incompatible pointer type [-Werror]
>>>        fstat_is_blkdev(tfd, dv->devname, &rdev);
>>>        ^
>>> In file included from Manage.c:25:0:
>>> mdadm.h:1446:12: note: expected 'dev_t *' but argument is of type 'long
>>> unsigned int *'
>>>
>>> It was introduced by 0a6bff09 and add a temp variable to fix this.
>>
>> Maybe: It is introduced by commit 0a6bff09 (mdadm/util: unify fstat
>> checking blkdev into function). So use a temp variable to fix this.
> 
> Yes, the word so is better. Sorry for my pool English.

Please don’t be sorry, everybody learns, and please note, I am no native 
speaker.

>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>> ---
>>>    Manage.c | 6 ++++--
>>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Manage.c b/Manage.c
>>> index 871d342..fbb07ce 100644
>>> --- a/Manage.c
>>> +++ b/Manage.c
>>> @@ -1497,13 +1497,14 @@ int Manage_subdevs(char *devname, int fd,
>>>    			 */
>>>    			rdev = makedev(mj, mn);
>>>    		} else {
>>> +			dev_t rdev_tmp;
>>
>> Can we get a better name?
> 
> Ok, is it better to use device_id?

Sounds good to me.

>>>    			tfd = dev_open(dv->devname, O_RDONLY);
>>>    			if (tfd >= 0) {
>>> -				fstat_is_blkdev(tfd, dv->devname, &rdev);
>>> +				fstat_is_blkdev(tfd, dv->devname, &rdev_tmp);
>>>    				close(tfd);
>>>    			} else {
>>>    				int open_err = errno;
>>> -				if (!stat_is_blkdev(dv->devname, &rdev)) {
>>> +				if (!stat_is_blkdev(dv->devname, &rdev_tmp)) {
>>>    					if (dv->disposition == 'M')
>>>    						/* non-fatal. Also improbable */
>>>    						continue;
>>> @@ -1523,6 +1524,7 @@ int Manage_subdevs(char *devname, int fd,
>>>    					goto abort;
>>>    				}
>>>    			}
>>> +			rdev = (unsigned long)rdev_tmp;
>>
>> Are ou sure that this won’t cause problems on other platforms
>> (32-bit/64-bit)?
> 
> Could you explain this in detail? Function fstat_is_blkdev needs to pass a
> dev_t variable to it. But rdev is unsinged long. So it needs to cast dev_t
> to unsigned long.

Sorry, I was probably wrong. I just remembered that long has different 
sizes on 32-bit and 64-bit systems.

• /usr/include/sys/stat.h:typedef __dev_t dev_t;• 
/usr/include/bits/types.h:__STD_TYPE __DEV_T_TYPE __dev_t;	/* Type of 
device numbers.  */
• /usr/include/bits/typesizes.h:#define __DEV_T_TYPE		__UQUAD_TYPE

So we depend on the assumption that `long unsigned int` is as long as 
`__UQUAD_TYPE`. Unfortunately, I couldn’t find the definition for 
`__UQUAD_TYPE`. So ignore my comment for now. Maybe somebody else can 
shed some light.


Kind regards,

Paul
