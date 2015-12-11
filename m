From: "P. Remek" <p.remek1@googlemail.com>
Subject: Re: start dm-multipath before mdadm raid
Date: Fri, 11 Dec 2015 17:01:37 +0100
Message-ID: <CABdHLQ7Wdg1sUdC-Ryamdy+et6SNJRJnfdnRXSPOrWJYX9sT_g@mail.gmail.com>
References: <CABdHLQ6Lo8WvgSf=MAuYdVoJJMHmLuV5gkE+N4MDMfxvAbG5OA@mail.gmail.com>
	<5669AE9C.7040904@turmel.org>
	<CABdHLQ4rh+Rtu6U+ZX6m0CWXu3sW4boEzHaPdxD03UBf82EJcQ@mail.gmail.com>
	<566AD7EA.4070903@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <566AD7EA.4070903@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here is my config:

root@os-node1:~# uname  -a
Linux os-node1 3.16.0-48-generic #64~14.04.1-Ubuntu SMP Thu Aug 20
23:03:57 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux





root@os-node1:~# cat /etc/mdadm/mdadm.conf

DEVICE /dev/mapper/hgst-ssd*
CREATE owner=root group=disk mode=0660 auto=yes
HOMEHOST <system>
MAILADDR root
ARRAY /dev/md0 metadata=0.90 UUID=4472a74f:ca206897:3b82bcad:daeae9f9






root@os-node1:~# cat /etc/multipath.conf

blacklist {
       wwid 3600508b1001cbb0c5b5a2fe0a85e0053
       wwid 3600508b1001c33e8fe607dfd73043d03
       wwid 32020030102060804

}


multipaths {
       multipath {
               wwid                    35000cca04f1cbdfc
               alias                   hgst-ssd1
               path_grouping_policy    multibus
               path_selector           "round-robin 0"
               failback                2
               rr_weight               uniform
               no_path_retry           0
               rr_min_io               1000
       }

       multipath {
               wwid                    35000cca04f1cc050
               alias                   hgst-ssd2
               path_grouping_policy    multibus
               path_selector           "round-robin 0"
               failback                2
               rr_weight               uniform
               no_path_retry           0
               rr_min_io               1000
       }

       multipath {
               wwid                    35000cca04f1ce930
               alias                   hgst-ssd3
               path_grouping_policy    multibus
               path_selector           "round-robin 0"
               failback                2
               rr_weight               uniform
               no_path_retry           0
               rr_min_io               1000
       }

       multipath {
               wwid                    35000cca04f1ce1f4
               alias                   hgst-ssd4
               path_grouping_policy    multibus
               path_selector           "round-robin 0"
               failback                2
               rr_weight               uniform
               no_path_retry           0
               rr_min_io               1000
       }

       multipath {
               wwid                    35000cca04f1cbe18
               alias                   hgst-ssd5
               path_grouping_policy    multibus
               path_selector           "round-robin 0"
               failback                2
               rr_weight               uniform
               no_path_retry           0
               rr_min_io               1000
       }

       multipath {
               wwid                    35000cca04f1cdc58
               alias                   hgst-ssd6
               path_grouping_policy    multibus
               path_selector           "round-robin 0"
               failback                2
               rr_weight               uniform
               no_path_retry           0
               rr_min_io               1000



with this config I do:

root@os-node1:~# update-initramfs -u
update-initramfs: Generating /boot/initrd.img-3.16.0-48-generic


Then I reboot the computer but the mdadm raid doesn't start up. The
multipathed devides does start up:


root@os-node1:~# multipath -ll
Error: : Inappropriate ioctl for device
cciss TUR  failed in CCISS_GETLUNINFO: Inappropriate ioctl for device
Error: : Inappropriate ioctl for device
cciss TUR  failed in CCISS_GETLUNINFO: Inappropriate ioctl for device
hgst-ssd6 (35000cca04f1cdc58) dm-5 HGST    ,HUSMM1680ASS200
size=745G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  |- 3:0:2:0 sde   8:64   active ready  running
  `- 4:0:2:0 sdk   8:160  active ready  running
hgst-ssd5 (35000cca04f1cbe18) dm-7 HGST    ,HUSMM1680ASS200
size=745G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  |- 3:0:4:0 sdg   8:96   active ready  running
  `- 4:0:4:0 sdm   8:192  active ready  running
hgst-ssd4 (35000cca04f1ce1f4) dm-3 HGST    ,HUSMM1680ASS200
size=745G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  |- 3:0:0:0 sdc   8:32   active ready  running
  `- 4:0:0:0 sdi   8:128  active ready  running
hgst-ssd3 (35000cca04f1ce930) dm-4 HGST    ,HUSMM1680ASS200
size=745G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  |- 3:0:1:0 sdd   8:48   active ready  running
  `- 4:0:1:0 sdj   8:144  active ready  running
hgst-ssd2 (35000cca04f1cc050) dm-8 HGST    ,HUSMM1680ASS200
size=745G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  |- 3:0:5:0 sdh   8:112  active ready  running
  `- 4:0:5:0 sdn   8:208  active ready  running
hgst-ssd1 (35000cca04f1cbdfc) dm-6 HGST    ,HUSMM1680ASS200
size=745G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  |- 3:0:3:0 sdf   8:80   active ready  running
  `- 4:0:3:0 sdl   8:176  active ready  running


Regards,
Remek


On Fri, Dec 11, 2015 at 3:04 PM, Phil Turmel <philip@turmel.org> wrote:
> On 12/10/2015 05:44 PM, P. Remek wrote:
>>>
>>> Order of device discovery is not guaranteed, but base devices will
>>> almost always show up before multipath devices.  You have to filter out
>>> the base devices from mdadm consideration:
>>>
>>> Add a DEVICES statement to your mdadm.conf that only matches your
>>> multipath device names, not the base names.  Then update your initramfs
>>> so it applies to early boot as well.
>>>
>>
>>
>> This is something which I actually already tried. I specified in my
>> /etc/mdadm/mdadm.conf following:
>>
>> DEVICE /dev/mapper/hgst-ssd*
>>
>> In my /etc/multipath.conf I instruct dm-multipath to create
>> /dev/mapper/hgst-ssd1 /dev/mapper/hgst-ssd2 /dev/mapper/hgst-ssd3
>
> You haven't said that you've updated your initramfs with this info.
>
>> But the only result is that after this config, the md raid is not
>> started at all. My conclusion was that when md raid was starting, the
>> multipath devices did not yet exist so it did not start up the array.
>
> That would be an initramfs bug, most likely.  Modern initramfs like
> dracut use incremental assembly to start arrays and subsystems as
> devices are started, regardless what order they show up.
>
> Phil
>
