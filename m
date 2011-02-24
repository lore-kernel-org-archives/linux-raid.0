From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: failed drive in raid 1 array
Date: Thu, 24 Feb 2011 16:32:58 -0500
Message-ID: <4D66CE8A.90105@cdf.toronto.edu>
References: <4D653B57.1030203@supsi.ch>	<AANLkTim+Sz9Hrpu0rPQt2r4-SgmGEt1svsrs26Ejrkoq@mail.gmail.com>	<4D655D01.6040803@supsi.ch>	<AANLkTimQhfvbx72izkg9qxMFkC0xixTPQa6aQ4HF04Hq@mail.gmail.com>	<4D657AFE.3010605@supsi.ch>	<AANLkTikKtkwHATrSE7Ymf2n22Fj06kw9fpNwTr-8WyS1@mail.gmail.com>	<4D658672.4000503@supsi.ch>	<4D6681E1.5010905@cdf.toronto.edu> <AANLkTinkz2Aq+EDh10-98wYTrDU7+h4F3FOpk2Mu6nqd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050509000902030401040902"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinkz2Aq+EDh10-98wYTrDU7+h4F3FOpk2Mu6nqd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Roberto Nunnari <roberto.nunnari@supsi.ch>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------050509000902030401040902
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Roberto (Spadim),

I am attaching the two files necessary for this functionality. The first 
one (gpt_id) is the script which given this example input:

   gpt_id sdb 1

should give this example output:

   PARTITION_LABEL=itest00-drive00-part00

The second file is a udev configuration file which needs to be dropped 
into /etc/udev/rules.d/. When a new device is attached, it runs gpt_id 
on its partitions, and if a GPT label is found, a link in 
/dev/disk/by-label magically appears to the partition in question.

To create a GPT label and name a 100GB partition on /dev/sdb, one would 
do something like this (WARNING, WARNING, WARNING THIS IS A 
DATA-DESTRUCTIVE PROCESS):

parted /dev/sdb
mklabel y gpt
mkpart primary ext3 0 100GB
name 1 itest00-drive00-part00
print
quit

To trigger udevadm to rescan all the devices and remake all the 
symlinks, you can run:

udevadm trigger

The gpt_id and the udev rules file are home-brewed at our department. Enjoy!

Cheers,
Iordan

On 02/24/11 15:08, Roberto Spadim wrote:
> do you have the udev configuration for this (static)?
>
> 2011/2/24 Iordan Iordanov<iordan@cdf.toronto.edu>:
>> Hi guys,
>>
>> I saw a bunch of discussion of devices changing names when hot-plugged. If
>> you get the device name right when you add it to the array first, all is
>> good since the superblock is used to "discover" the device later.
>>
>> However, to make things easier/clearer, and to avoid errors, one can take a
>> look at the set of directories:
>>
>> /dev/disk/by-id
>> /dev/disk/by-path
>> /dev/disk/by-uuid
>> /dev/disk/by-label
>>
>> for a predictable, more static view of the drives. The symlinks in these
>> directories are created by udev, and are simply links to the "real" device
>> nodes /dev/sd{a-z}*. You can either just use these symlinks as a way of
>> verifying that you are adding the right device, or add the device using the
>> symlink.
>>
>> At our location, we even augmented udev to add links to labeled GPT
>> partitions in /dev/disk/by-label, and now our drives/partitions look like
>> this:
>>
>> iscsi00-drive00-part00 ->  ../../sda1
>> iscsi00-drive01-part00 ->  ../../sdb1
>> iscsi00-drive02-part00 ->  ../../sdc1
>> iscsi00-drive03-part00 ->  ../../sdd1
>> iscsi00-drive04-part00 ->  ../../sde1
>>
>> This way, we know exactly which bay contains exactly which drive, and it
>> stays this way. If you guys want, I can share with you the changes to udev
>> necessary and the script which extracts the GPT label and reports it to udev
>> for this magic to happen :). Please reply to this thread with a request if
>> you think it may be useful to you.
>>
>> Cheers,
>> Iordan
>>
>>
>> On 02/23/11 17:13, Roberto Nunnari wrote:
>>>
>>> Roberto Spadim wrote:
>>>>
>>>> hum, maybe you are using mdadm.conf or autodetect, non autodetect
>>>> should be something like this:
>>>> i don´t know the best solution, but it works ehhehe
>>>>
>>>> kernel /vmlinuz-2.6.9-89.31.1.ELsmp ro root=/dev/md0 rhgb
>>>> quiet md=0,/dev/sda,/dev/sdb md=1,xxxx,yyyy.....
>>>>
>>>> or another md array...
>>>>
>>>> humm i readed the sata specification and removing isn´t a problem, at
>>>> eletronic level the sata channel is only data, no power source, all
>>>> channels are diferencial (like rs422 or rs485), i don´t see anyproblem
>>>> removing it. i tryed hot plug a revodrive (pciexpress ssd) and it
>>>> don´t work (reboot) hehehe, pci-express isn´t hot plug =P, sata2 don´t
>>>> have problems, the main problem is a short circuit at power source, if
>>>> you remove with caution no problems =)
>>>>
>>>> i tried in some others distros and udev created a new device when add
>>>> a diferent disk for example, remove sdb, and add another disk create
>>>> sdc (not sdb), maybe with another udev configuration should work
>>>
>>> Ok. I'll keep all that in mind tomorrow.
>>> Best regards.
>>> Robi
>>>
>>>
>>>>
>>>>
>>>> 2011/2/23 Roberto Nunnari<roberto.nunnari@supsi.ch>:
>>>>>
>>>>> Roberto Spadim wrote:
>>>>>>
>>>>>> i don´t know how you setup your kernel (with or without raid
>>>>>
>>>>> I use the official CentOS kernel with no modification and don't
>>>>> know about raid autodetect, but:
>>>>> # cat /boot/config-2.6.24-28-server |grep -i raid
>>>>> CONFIG_BLK_DEV_3W_XXXX_RAID=m
>>>>> CONFIG_MD_RAID0=m
>>>>> CONFIG_MD_RAID1=m
>>>>> CONFIG_MD_RAID10=m
>>>>> CONFIG_MD_RAID456=m
>>>>> CONFIG_MD_RAID5_RESHAPE=y
>>>>> CONFIG_MEGARAID_LEGACY=m
>>>>> CONFIG_MEGARAID_MAILBOX=m
>>>>> CONFIG_MEGARAID_MM=m
>>>>> CONFIG_MEGARAID_NEWGEN=y
>>>>> CONFIG_MEGARAID_SAS=m
>>>>> CONFIG_RAID_ATTRS=m
>>>>> CONFIG_SCSI_AACRAID=m
>>>>>
>>>>>
>>>>>> autodetect?) do you use kernel command line to setup raid? autodetect?
>>>>>
>>>>> /dev/md0 in grub
>>>>> I don't know if that means autodetect, but I guess so..
>>>>>
>>>>>
>>>>>> here in my test machine i´m using kernel command line (grub), i don´t
>>>>>> have a server with hotplug bay, i open the case and remove the wire
>>>>>> with my hands =) after reconecting it with another device kerenel
>>>>>
>>>>> Is it safe? Isn't it a blind bet to fry up the controller and/or disk?
>>>>>
>>>>>
>>>>>> recognize the new device reread the parititions etc etc and i can add
>>>>>> it to array again
>>>>>> my grub is something like:
>>>>>>
>>>>>> md=0,/dev/sda,/dev/sdb .....
>>>>>>
>>>>>> internal meta data, raid1, i didn´t like the autodetect (it´s good)
>>>>>> but i prefer hardcoded kernel command line (it´s not good with usb
>>>>>> devices)
>>>>>
>>>>> the relevant part of my grub is:
>>>>>
>>>>> default=0
>>>>> timeout=5
>>>>> splashimage=(hd0,0)/grub/splash.xpm.gz
>>>>> hiddenmenu
>>>>> title CentOS (2.6.9-89.31.1.ELsmp)
>>>>> root (hd0,0)
>>>>> kernel /vmlinuz-2.6.9-89.31.1.ELsmp ro root=/dev/md0 rhgb quiet
>>>>> initrd /initrd-2.6.9-89.31.1.ELsmp.img
>>>>>
>>>>> Best regards.
>>>>> Robi
>>>>>
>>>>>
>>>>>> 2011/2/23 Roberto Nunnari<roberto.nunnari@supsi.ch>:
>>>>>>>
>>>>>>> Roberto Spadim wrote:
>>>>>>>>
>>>>>>>> sata2 without hot plug?
>>>>>>>
>>>>>>> Hi Roberto.
>>>>>>>
>>>>>>> I mean that there is no hot-plug bay, with sliding rails etc..
>>>>>>> The drives are connected to the mb using standard sata cables.
>>>>>>>
>>>>>>>
>>>>>>>> check if your sda sdb sdc will change after removing it, it愀 depends
>>>>>>>> on your udev or another /dev filesystem
>>>>>>>
>>>>>>> Ok, thank you.
>>>>>>> That means that if I take care to check the above, and
>>>>>>> the new drive will be sdb, then taking the steps indicated
>>>>>>> in my original post will do the job?
>>>>>>>
>>>>>>> Best regards.
>>>>>>> Robi
>>>>>>>
>>>>>>>
>>>>>>>> 2011/2/23 Roberto Nunnari<roberto.nunnari@supsi.ch>:
>>>>>>>>>
>>>>>>>>> Hello.
>>>>>>>>>
>>>>>>>>> I have a linux box, with two 2TB sata HD in raid 1.
>>>>>>>>>
>>>>>>>>> Now, one disk is in failed state and it has no spares:
>>>>>>>>> # cat /proc/mdstat
>>>>>>>>> Personalities : [raid1]
>>>>>>>>> md1 : active raid1 sdb4[2](F) sda4[0]
>>>>>>>>> 1910200704 blocks [2/1] [U_]
>>>>>>>>>
>>>>>>>>> md0 : active raid1 sdb1[1] sda2[0]
>>>>>>>>> 40957568 blocks [2/2] [UU]
>>>>>>>>>
>>>>>>>>> unused devices:<none>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> The drives are not hot-plug, so I need to shutdown the box.
>>>>>>>>>
>>>>>>>>> My plan is to:
>>>>>>>>> # sfdisk -d /dev/sdb>  sdb.sfdisk
>>>>>>>>> # mdadm /dev/md1 -r /dev/sdb4
>>>>>>>>> # mdadm /dev/md0 -r /dev/sdb1
>>>>>>>>> # shutdown -h now
>>>>>>>>>
>>>>>>>>> replace the disk and boot (it should come back up, even without one
>>>>>>>>> drive,
>>>>>>>>> right?)
>>>>>>>>>
>>>>>>>>> # sfdisk /dev/sdb<  sdb.sfdisk
>>>>>>>>> # mdadm /dev/md1 -a /dev/sdb4
>>>>>>>>> # mdadm /dev/md0 -a /dev/sdb1
>>>>>>>>>
>>>>>>>>> and the drives should start to resync, right?
>>>>>>>>>
>>>>>>>>> This is my first time I do such a thing, so please, correct me
>>>>>>>>> if the above is not correct, or is not a best practice for
>>>>>>>>> my configuration.
>>>>>>>>>
>>>>>>>>> My last backup of md1 is of mid november, so I need to be
>>>>>>>>> pretty sure I will not lose my data (over 1TB).
>>>>>>>>>
>>>>>>>>> A bit abount my environment:
>>>>>>>>> # mdadm --version
>>>>>>>>> mdadm - v1.12.0 - 14 June 2005
>>>>>>>>> # cat /etc/redhat-release
>>>>>>>>> CentOS release 4.8 (Final)
>>>>>>>>> # uname -rms
>>>>>>>>> Linux 2.6.9-89.31.1.ELsmp i686
>>>>>>>>>
>>>>>>>>> Thank you very much and best regards.
>>>>>>>>> Robi
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>

--------------050509000902030401040902
Content-Type: text/plain;
 name="gpt_id"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="gpt_id"

IyEvYmluL3NoCgpQQVJFTlRfREVWSUNFPSIkMSIKUEFSVElUSU9OPSIkMiIKCiMgR2V0IHRo
ZSBsYWJlbCBvZiB0aGUgcGFydGl0aW9uIHVzaW5nIHBhcnRlZC4KUEFSVElUSU9OX0xBQkVM
PSJgcGFydGVkIC1zbSAvZGV2LyIkUEFSRU5UX0RFVklDRSIgcHJpbnQgfCBncmVwICJeJFBB
UlRJVElPTjoiIHwgYXdrIC1GOiAne3ByaW50ICQ2fSdgIgoKZWNobyAiUEFSVElUSU9OX0xB
QkVMPSRQQVJUSVRJT05fTEFCRUwiCg==
--------------050509000902030401040902
Content-Type: text/plain;
 name="10-gpt-label.rules"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="10-gpt-label.rules"

IyBUaGlzIGZpbGUgY29udGFpbnMgdGhlIHJ1bGVzIHRvIGNyZWF0ZSBieS1HUFQtbGFiZWwg
c3ltbGlua3MgZm9yIGRldmljZXMKCiMgZm9yd2FyZCBzY3NpIGRldmljZSBldmVudHMgdG8g
dGhlIGNvcnJlc3BvbmRpbmcgYmxvY2sgZGV2aWNlCkFDVElPTj09ImNoYW5nZSIsIFNVQlNZ
U1RFTT09InNjc2kiLCBFTlZ7REVWVFlQRX09PSJzY3NpX2RldmljZSIsIFwKCVRFU1Q9PSJi
bG9jayIsCQkJQVRUUntibG9jay8qL3VldmVudH09ImNoYW5nZSIKCiMgd2UgYXJlIG9ubHkg
aW50ZXJlc3RlZCBpbiBhZGQgYW5kIGNoYW5nZSBhY3Rpb25zIGZvciBibG9jayBkZXZpY2Vz
CkFDVElPTiE9ImFkZHxjaGFuZ2UiLAkJCUdPVE89ImdwdF9sYWJlbF9lbmQiClNVQlNZU1RF
TSE9ImJsb2NrIiwJCQlHT1RPPSJncHRfbGFiZWxfZW5kIgoKIyBhbmQgd2UgY2FuIHNhZmVs
eSBpZ25vcmUgdGhlc2Uga2luZHMgb2YgZGV2aWNlcwpLRVJORUw9PSJtdGRbMC05XSp8bXRk
YmxvY2tbMC05XSp8cmFtKnxsb29wKnxmZCp8bmJkKnxnbmJkKnxkbS0qfG1kKnxidGlibSoi
LCBHT1RPPSJncHRfbGFiZWxfZW5kIgoKIyBza2lwIHJlbW92YWJsZSBpZGUgZGV2aWNlcywg
YmVjYXVzZSBvcGVuKDIpIG9uIHRoZW0gY2F1c2VzIGFuIGV2ZW50cyBsb29wCktFUk5FTD09
ImhkKlshMC05XSIsIEFUVFJ7cmVtb3ZhYmxlfT09IjEiLCBEUklWRVJTPT0iaWRlLWNzfGlk
ZS1mbG9wcHkiLCBcCgkJCQkJR09UTz0iZ3B0X2xhYmVsX2VuZCIKS0VSTkVMPT0iaGQqWzAt
OV0iLCBBVFRSU3tyZW1vdmFibGV9PT0iMSIsIFwKCQkJCQlHT1RPPSJncHRfbGFiZWxfZW5k
IgoKIyBza2lwIHhlbiB2aXJ0dWFsIGhhcmQgZGlza3MKRFJJVkVSUz09InZiZCIsCQkJCUdP
VE89Im5vX2hhcmR3YXJlX2lkIgoKIyBjaGVjayB0aGVzZSBhdHRyaWJ1dGVzIG9mIC9zeXMv
Y2xhc3MvYmxvY2sgbm9kZXMKRU5We0RFVlRZUEV9IT0iPyoiLCBBVFRSe3JhbmdlfT09Ij8q
IiwJRU5We0RFVlRZUEV9PSJkaXNrIgpFTlZ7REVWVFlQRX0hPSI/KiIsIEFUVFJ7c3RhcnR9
PT0iPyoiLAlFTlZ7REVWVFlQRX09InBhcnRpdGlvbiIKCiMgcHJvYmUgR1BUIHBhcnRpdGlv
biBsYWJlbCBvZiBkaXNrcwpLRVJORUwhPSJzcioiLCBFTlZ7REVWVFlQRX09PSJwYXJ0aXRp
b24iLCBJTVBPUlR7cHJvZ3JhbX09Ii9zYmluL2dwdF9pZCAkcGFyZW50ICRudW1iZXIiCgpF
TlZ7UEFSVElUSU9OX0xBQkVMfT09Ij8qIiwgU1lNTElOSys9ImRpc2svYnktbGFiZWwvJGVu
dntQQVJUSVRJT05fTEFCRUx9IgoKTEFCRUw9ImdwdF9sYWJlbF9lbmQiCg==
--------------050509000902030401040902--
