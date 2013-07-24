From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: MD array keeps resyncing after rebooting
Date: Wed, 24 Jul 2013 15:50:48 +0200
Message-ID: <CAC9WiBjQz6MJxBuw+cLWFZ-vOsdbYYSKdE575emH_AG5EmnGdw@mail.gmail.com>
References: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>
	<CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>
	<51EED0DA.3020901@arcor.de>
	<51EED102.4020503@arcor.de>
	<CAC9WiBgN1-HBEgqwo7CWor=nihCYUcOrYKhGxYTgbC-d4a7_-g@mail.gmail.com>
	<51EEF3D3.7020305@arcor.de>
	<CAC9WiBgrjrPRcHa5kh8TUfqN0rBBFC4M0_8iDkU3O0SOFgFW5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBgrjrPRcHa5kh8TUfqN0rBBFC4M0_8iDkU3O0SOFgFW5g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 24, 2013 at 6:32 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> On Tue, Jul 23, 2013 at 11:21 PM, Martin Wilck <mwilck@arcor.de> wrote:
>> On 07/23/2013 10:01 PM, Francis Moreau wrote:
>>> Hello Martin
>>>
>>> On Tue, Jul 23, 2013 at 8:52 PM, Martin Wilck <mwilck@arcor.de> wrote:
>>>> On 07/23/2013 08:52 PM, Martin Wilck wrote:
>>>>> Which MD version are you using?
>>>>
>>>> I meant: which mdadm version. Sorry.
>>>>
>>>
>>> I'm using mdadm version 3.2.3
>>>
>>> I'll give the current git version a try tomorrow.
>>>
>>> The thing is that I need to wait the sync to finish in order to test
>>> this problem. But the sync takes a while (> 4 hours, I don't remember
>>> exactly). Are there any ways to speed up the process ?
>>
>> MD will adjust its speed while initializing, thus the fastest way is to
>> do nothing on the system, avoiding any other disk IO. This will cause MD
>> to use max bandwidth.
>>
>> One thing you can do for testing is to create a smaller array which will
>> of course initialize faster.
>
> Unfortunately I can't do that: the array was created by the BIOS and
> AFAICS it does on the whole disks.
>
>>
>> Please run mdadm -E /dev/sdX for all RAID disks before and after reboot
>> and watch out for differences.
>
> Will do.
>

So I let the sync to finish, it was with my old version of mdadm (3.2.3).

While syncing, I installed the latest mdadm git version:

 $ mdadm --version
 mdadm - v3.3-rc1-94-g4441541 - 23th July 2013

Note that I only installed the 2 binaries mdadm/mdmon, I leave the
udev rules for md devices untouched.

I regenerated the initramfs in order to use the new binaries when
booting and now I can see some new warnings:

  $ dracut -f
  mdmon: Failed to load secondary DDF header on /dev/block/8:0
  mdmon: Failed to load secondary DDF header on /dev/block/8:16
  ...

I ignored them for now.

Now the latest version of mdadm is used :

  $ cat /proc/mdstat
  Personalities : [raid1]
  md126 : active raid1 sdb[1] sda[0]
        975585280 blocks super external:/md127/0 [2/2] [UU]

  md127 : inactive sdb[1](S) sda[0](S)
        2354608 blocks super external:ddf

I run mdadm -E /dev/sdX for all RAID disks before and after reboot.
I'm still having this warning:

   mdmon: Failed to load secondary DDF header on /dev/sda

You can find the differences below:

diff -Nurp before/sda.txt after/sda.txt
--- before/sda.txt      2013-07-24 15:15:33.304015379 +0200
+++ after/sda.txt       2013-07-24 15:49:09.520132838 +0200
@@ -9,11 +9,11 @@ Controller GUID : 4C534920:20202020:FFFF
   Redundant hdr : yes
   Virtual Disks : 1

-      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F2103E0:00001450
-                  (LSI      07/24/13 12:18:08)
+      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F213401:00001450
+                  (LSI      07/24/13 15:43:29)
          unit[0] : 0
         state[0] : Optimal, Not Consistent
-   init state[0] : Fully Initialised
+   init state[0] : Not Initialised
        access[0] : Read/Write
          Name[0] : array0
  Raid Devices[0] : 2 (0 1)
diff -Nurp before/sdb.txt after/sdb.txt
--- before/sdb.txt      2013-07-24 15:17:50.300581049 +0200
+++ after/sdb.txt       2013-07-24 15:49:15.159997204 +0200
@@ -9,11 +9,11 @@ Controller GUID : 4C534920:20202020:FFFF
   Redundant hdr : yes
   Virtual Disks : 1

-      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F2103E0:00001450
-                  (LSI      07/24/13 12:18:08)
+      VD GUID[0] : 4C534920:20202020:80861D60:00000000:3F213401:00001450
+                  (LSI      07/24/13 15:43:29)
          unit[0] : 0
         state[0] : Optimal, Not Consistent
-   init state[0] : Fully Initialised
+   init state[0] : Not Initialised
        access[0] : Read/Write
          Name[0] : array0
  Raid Devices[0] : 2 (0 1)


Does this help ?

Thanks
-- 
Francis
