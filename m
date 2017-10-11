From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be
 needed.
Date: Wed, 11 Oct 2017 15:39:25 +0800
Message-ID: <375cf2fb-bd4b-abef-5012-1361c224d254@suse.com>
References: <87y3p372b0.fsf@notabene.neil.brown.name>
 <cba5f77f-d6de-7a6b-35b0-70b7c56eb3f7@suse.com>
 <87bmleyd0y.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87bmleyd0y.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 10/11/2017 04:16 AM, NeilBrown wrote:
> On Tue, Oct 10 2017, Zhilong Liu wrote:
>
>> On 09/25/2017 01:52 PM, NeilBrown wrote:
>>> Creating an array by opening a block-device with major number of 9
>>> will transparently load the md module if needed.
>>> Creating an array by opening
>>>      /sys/module/md_mod/parameters/new_array
>>> and writing to it won't, it will just fail if md_mod isn't loaded.
>>>
>>> So when opening that file fails with ENOENT, run "modprobe md_mod" and
>>> try again.
>>>
>>> This fixes a bug whereby if you have "CREATE names=yes" in mdadm.conf,
>>> and the md modules isn't loaded, then creating or assembling an
>>> array will not honor the "names=yes" configuration.
>>>
>>> Signed-off-by: NeilBrown <neilb@suse.com>
>>> ---
>>>    mdopen.c | 4 ++++
>>>    1 file changed, 4 insertions(+)
>>>
>>> diff --git a/mdopen.c b/mdopen.c
>>> index 3c0052f2db23..dcdc6f23e6c1 100644
>>> --- a/mdopen.c
>>> +++ b/mdopen.c
>>> @@ -312,6 +312,10 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
>>>    		if (block_udev)
>>>    			udev_block(devnm);
>>>    		fd = open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
>>> +		if (fd < 0 && errno == ENOENT) {
>>> +			system("modprobe md_mod");
[nip]
> Hmmm.. that's annoying.  I wonder why "system" is marked
> "warn_unused_result".

in /usr/include/stdlib.h:
...
712 /* Execute the given line as a shell command.
713
714    This function is a cancellation point and therefore not marked with
715    __THROW.  */
716 extern int system (const char *__command) __wur;
...

the "warn_unused_result" is from the __wur parameter, re-compile mdadm 
after delete the '__wur',
it works.

> In this case I really don't care - I'm not convinced an extra error
> message will really help.
> Maybe
>     if (system("modprobe md_mod") == 0)
>          fd = open("/sys/......", O_WRONLY);

Agree.
>
> We do what a better error message, then it should be based on 'fd < 0'.
> e.g.
>    if (fd < 0 || n != strlen(devnm))
>        pr_err("Fail create array using /sys/module/md_mod/parameters/new_array\n");

you mean something like this?

diff --git a/mdopen.c b/mdopen.c
index dcdc6f2..9de347e 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -313,14 +313,17 @@ int create_mddev(char *dev, char *name, int autof, 
int trustworthy,
                         udev_block(devnm);
                 fd = open("/sys/module/md_mod/parameters/new_array", 
O_WRONLY);
                 if (fd < 0 && errno == ENOENT) {
-                       system("modprobe md_mod");
-                       fd = 
open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
+                       if (system("modprobe md_mod") == 0)
+                               fd = 
open("/sys/module/md_mod/parameters/new_array",
+                                         O_WRONLY);
                 }
                 if (fd >= 0) {
                         n = write(fd, devnm, strlen(devnm));
                         close(fd);
                 }
-               if (n < 0) {
+               if (fd < 0 || n != strlen(devnm)) {
+                       pr_err("Fail create array using "
+ "/sys/module/md_mod/parameters/new_array\n");
                         devnm[0] = 0;
                         udev_unblock();
                 }


Thanks,
-Zhilong

> Thanks,
> NeilBrown

