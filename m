From: Zhilong Liu <zlliu@suse.com>
Subject: Re: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be
 needed.
Date: Fri, 13 Oct 2017 17:16:17 +0800
Message-ID: <4bfc741e-c9e6-1645-fc2b-f90da1c7cc20@suse.com>
References: <87y3p372b0.fsf@notabene.neil.brown.name>
 <cba5f77f-d6de-7a6b-35b0-70b7c56eb3f7@suse.com>
 <87bmleyd0y.fsf@notabene.neil.brown.name>
 <375cf2fb-bd4b-abef-5012-1361c224d254@suse.com>
 <87h8v5nsa6.fsf@notabene.neil.brown.name>
 <7631f4ae-bcc5-b36d-bb63-678515109f05@suse.com>
 <87zi8wn44l.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zi8wn44l.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 10/12/2017 04:48 PM, NeilBrown wrote:
>> On 10/12/2017 08:06 AM, NeilBrown wrote:
> I wouldn't worry too much about checkpatch.pl.
> It is worth looking at what it reports, but if you don't agree or the
> maintainer doesn't agree, then feel free to ignore it.
>
>
>> Is this changing ok to you?
>>
>> diff --git a/mdopen.c b/mdopen.c
>> index dcdc6f2..da8d9d1 100644
>> --- a/mdopen.c
>> +++ b/mdopen.c
>> @@ -26,6 +26,8 @@
>>    #include "md_p.h"
>>    #include <ctype.h>
>>
>> +#define NEW_ARRAY_FILE "/sys/module/md_mod/parameters/new_array"
>> +
> Splitting this out into a separate string does make sense.
> However I would use
>    static const char new_array_file[] = ....;
> rather than #define.

Maybe "const char *" is enough for this long string? Because this file 
only used when
creating named array, not global using.

> I hadn't noticed that there are two places where we write to new_array.
> Maybe that should be split out into a function.
> Both should use modprobe if the open fails.

how about this changing? Thanks for your patience to have a look at it.


diff --git a/mdopen.c b/mdopen.c
index dcdc6f2..6d8402d 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -100,6 +100,29 @@ void make_parts(char *dev, int cnt)
         free(name);
  }

+int create_named_array(char *devnm)
+{
+       const char *file = "/sys/module/md_mod/parameters/new_array";
+       int fd;
+       int n = -1;
+
+       fd = open(file, O_WRONLY);
+       if (fd < 0 && errno == ENOENT) {
+               if (system("modprobe md_mod") == 0)
+                       fd = open(file, O_WRONLY);
+       }
+       if (fd >= 0) {
+               n = write(fd, devnm, strlen(devnm));
+               close(fd);
+       }
+       if (fd < 0 || n != (int)strlen(devnm)) {
+               pr_err("Fail create %s when using %s\n", devnm, file);
+               return 0;
+       }
+
+       return 1;
+}
+
  /*
   * We need a new md device to assemble/build/create an array.
   * 'dev' is a name given us by the user (command line or mdadm.conf)
@@ -306,37 +329,19 @@ int create_mddev(char *dev, char *name, int autof, 
int trustworthy,

         devnm[0] = 0;
         if (num < 0 && cname && ci->names) {
-               int fd;
-               int n = -1;
                 sprintf(devnm, "md_%s", cname);
                 if (block_udev)
                         udev_block(devnm);
-               fd = open("/sys/module/md_mod/parameters/new_array", 
O_WRONLY);
-               if (fd < 0 && errno == ENOENT) {
-                       system("modprobe md_mod");
-                       fd = 
open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
-               }
-               if (fd >= 0) {
-                       n = write(fd, devnm, strlen(devnm));
-                       close(fd);
-               }
-               if (n < 0) {
+               if (!create_named_array(devnm)) {
                         devnm[0] = 0;
                         udev_unblock();
                 }
         }
         if (num >= 0) {
-               int fd;
-               int n = -1;
                 sprintf(devnm, "md%d", num);
                 if (block_udev)
                         udev_block(devnm);
-               fd = open("/sys/module/md_mod/parameters/new_array", 
O_WRONLY);
-               if (fd >= 0) {
-                       n = write(fd, devnm, strlen(devnm));
-                       close(fd);
-               }
-               if (n < 0) {
+               if (!create_named_array(devnm)) {
                         devnm[0] = 0;
                         udev_unblock();
                 }

Thanks,
-Zhilong

> Thanks,
> NeilBrown
