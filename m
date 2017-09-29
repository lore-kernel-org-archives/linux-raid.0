From: Eli Ben-Shoshan <eli@benshoshan.com>
Subject: Re: Accidentally resized array to 9
Date: Fri, 29 Sep 2017 17:49:00 -0400
Message-ID: <4291101a-e239-0480-f3d8-cc1f0562e652@benshoshan.com>
References: <0e59cefd-662f-bf77-0c32-49424d504c77@benshoshan.com>
 <22990.16096.295333.439814@quad.stoffel.home>
 <3760f13b-4f8f-4d9c-8382-96ee4f08d511@benshoshan.com>
 <22990.40961.77727.460505@quad.stoffel.home>
 <fadb48d2-0a09-a8fe-156b-754baaa55a27@benshoshan.com>
 <22990.47215.946193.433535@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22990.47215.946193.433535@quad.stoffel.home>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/29/2017 05:17 PM, John Stoffel wrote:
>>>>>> "Eli" == Eli Ben-Shoshan <eli@benshoshan.com> writes:
> 
> Eli> On 09/29/2017 03:33 PM, John Stoffel wrote:
>>>>>>>> "Eli" == Eli Ben-Shoshan <eli@benshoshan.com> writes:
>>>
> Eli> On 09/29/2017 08:38 AM, John Stoffel wrote:
>>>>>>>>>> "Eli" == Eli Ben-Shoshan <eli@benshoshan.com> writes:
>>>>>
> Eli> I need to add another disk to my array (/dev/md128) when I accidentally
> Eli> did an array resize to 9 with the following command:
>>>>>
> Eli> First I add the disk to the array with the following:
>>>>>
> Eli> mdadm --manage /dev/md128 --add /dev/sdl
>>>>>
> Eli> This was a RAID6 with 8 devices. Instead of using --grow with
> Eli> --raid-devices set to 9, I did the following:
>>>>>
> Eli> mdadm --grow /dev/md128 --size 9
>>>>>
> Eli> This happily returned without any errors so I went to go look at
> Eli> /proc/mdstat and did not see a resize operation going. So I shook my
> Eli> head and read the output of --grow --help and did the right thing which is:
>>>>>
> Eli> mdadm --grow /dev/md128 --raid-devices=9
>>>>>
> Eli> Right after that everything hit the fan. dmesg reported a lot of
> Eli> filesystem errors. I quickly stopped all processes that were using this
> Eli> device and unmounted the filesystems. I then, stupidly, decided to
> Eli> reboot before looking around.
>>>>>
>>>>>
>>>>> I think you *might* be able to fix this with just a simple:
>>>>>
>>>>> mdadm --grow /dev/md128 --size max
>>>>>
>>>>> And then try to scan for your LVM configuration, then fsck your volume
>>>>> on there.  I hope you had backups.
>>>>>
>>>>> And maybe there should be a warning when re-sizing raid array elements
>>>>> without a --force option if going smaller than the current size?
>>>
> Eli> I just tried that and got the following error:
>>>
> Eli> mdadm: Cannot set device size in this type of array
>>>
> Eli> Trying to go further down this path, I also tried to set the size
> Eli> explicitly with:
>>>
> Eli> mdadm --grow /dev/md150 --size 1953383512
>>>
> Eli> but got:
>>>
> Eli> mdadm: Cannot set device size in this type of array
>>>
> Eli> I am curious if my data is actually still there on disk.
>>>
> Eli> What does the --size with --grow actually do?
>>>
>>> It changes the size of each member of the array.  The man page
>>> explains it, though not ... obviously.
>>>
>>> Are you still running with the overlays?  That would explain why it
>>> can't resize them bigger.  But I'm also behind on email today...
> 
> 
> Eli> I was still using the overlay. I just tried the grow without the overlay
> Eli> and got the same error.
> 
> Hmm.. what do the partitions on the disk look like now?  You might
> need to do more digging.  But I would say that using --grow and having
> it *shrink* without any warnings is a bad idea for the mdadm tools.
> It should scream loudly and only run when forced to like that.
> 
> Aw crap... you used the whole disk.  I don't like doing this because
> A) if I get a disk slightly *smaller* than what I currently have, it
> will be painful, B) it's easy to use a small partition starting 4mb
> from the start and a few hundred Mb (or even a Gb) from the end.
> 
> In your case, can you try to do the 'mdadm --grow /dev/md### --size
> max' but with a version of mdadm compiled with debugging info, or at
> least using the latest version of the code if at all possible.
> 
> Grab it from https://github.com/neilbrown/mdadm  and when you
> configure it, make sure you enable debugging.  Or grab it from
> https://www.kernel.org/pub/linux/utils/raid/mdadm/ and try the same
> thing.
> 
> Can you show the output of: cat /proc/partitions as well?  Maybe you
> need to do:
> 
>    mdadm --grow <dev> --size ########
> 
> which is the smallest of the max size of all your disks.  Might
> work...
> 

ganon mdadm-4.0 # cat /proc/partitions
major minor  #blocks  name

    1        0       8192 ram0
    1        1       8192 ram1
    1        2       8192 ram2
    1        3       8192 ram3
    1        4       8192 ram4
    1        5       8192 ram5
    1        6       8192 ram6
    1        7       8192 ram7
    1        8       8192 ram8
    1        9       8192 ram9
    1       10       8192 ram10
    1       11       8192 ram11
    1       12       8192 ram12
    1       13       8192 ram13
    1       14       8192 ram14
    1       15       8192 ram15
    8        0  234431064 sda
    8        1     262144 sda1
    8        2  204472320 sda2
    8        3    2097152 sda3
    8       16  234431064 sdb
    8       17     262144 sdb1
    8       18  204472320 sdb2
    8       19    2097152 sdb3
    8       32 1953514584 sdc
    8       48 1953514584 sdd
    8       64 1953514584 sde
    8       80 1953514584 sdf
    8       96 1953514584 sdg
    9      126     262080 md126
    9      127  204341248 md127
  252        0    1572864 dm-0
  252        1    9437184 dm-1
  252        2    4194304 dm-2
  252        3   16777216 dm-3
  252        4   25165824 dm-4
  252        5    7340032 dm-5
  252        6    6291456 dm-6
  252        7   53477376 dm-7
  252        8    1048576 dm-8
    8      112 1953514584 sdh
    8      128 1953514584 sdi
    8      144 1953514584 sdj
    8      145    4194304 sdj1
    8      146     524288 sdj2
    8      147 1948793912 sdj3
    8      160 1953514584 sdk
    8      176 1953514584 sdl
    8      192 1953514584 sdm
    8      193    4194304 sdm1
    8      194     524288 sdm2
    8      195 1948793912 sdm3
    9      131 1948662656 md131
    9      129    4192192 md129
    9      130     523968 md130

I got mdadm-4.0 compile with debug flags. Here is the output starting 
with --assemble --scan

ganon mdadm-4.0 # ./mdadm --assemble --scan
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host14/port-14:5/end_device-14:5/target14:0:5/14:0:5:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host14/port-14:4/end_device-14:4/target14:0:4/14:0:4:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host14/port-14:3/end_device-14:3/target14:0:3/14:0:3:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host14/port-14:2/end_device-14:2/target14:0:2/14:0:2:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host14/port-14:1/end_device-14:1/target14:0:1/14:0:1:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host14/port-14:0/end_device-14:0/target14:0:0/14:0:0:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:1c.5/0000:04:00.0/ata13/host12/target12:0:0/12:0:0:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: /sys/devices/pci0000:00/0000:00:1f.2/ata10/host9/target9:0:0/9:0:0:0
mdadm: scan: ptr->vendorID: 1103 __le16_to_cpu(ptr->deviceID): 2720
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: /sys/devices/pci0000:00/0000:00:1f.2/ata9/host8/target8:0:0/8:0:0:0
mdadm: scan: ptr->vendorID: 1103 __le16_to_cpu(ptr->deviceID): 2720
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: /sys/devices/pci0000:00/0000:00:1f.2/ata8/host7/target7:0:0/7:0:0:0
mdadm: scan: ptr->vendorID: 1103 __le16_to_cpu(ptr->deviceID): 2720
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: /sys/devices/pci0000:00/0000:00:1f.2/ata7/host6/target6:0:0/6:0:0:0
mdadm: scan: ptr->vendorID: 1103 __le16_to_cpu(ptr->deviceID): 2720
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: /sys/devices/pci0000:00/0000:00:1f.2/ata6/host5/target5:0:0/5:0:0:0
mdadm: scan: ptr->vendorID: 1103 __le16_to_cpu(ptr->deviceID): 2720
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: /sys/devices/pci0000:00/0000:00:1f.2/ata5/host4/target4:0:0/4:0:0:0
mdadm: scan: ptr->vendorID: 1103 __le16_to_cpu(ptr->deviceID): 2720
mdadm: start_array: /dev/md128 has been started with 9 drives.
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host14/port-14:5/end_device-14:5/target14:0:5/14:0:5:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host14/port-14:4/end_device-14:4/target14:0:4/14:0:4:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host14/port-14:3/end_device-14:3/target14:0:3/14:0:3:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host14/port-14:2/end_device-14:2/target14:0:2/14:0:2:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host14/port-14:1/end_device-14:1/target14:0:1/14:0:1:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:03.0/0000:01:00.0/host14/port-14:0/end_device-14:0/target14:0:0/14:0:0:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: 
/sys/devices/pci0000:00/0000:00:1c.5/0000:04:00.0/ata13/host12/target12:0:0/12:0:0:0
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: /sys/devices/pci0000:00/0000:00:1f.2/ata10/host9/target9:0:0/9:0:0:0
mdadm: scan: ptr->vendorID: 1103 __le16_to_cpu(ptr->deviceID): 2720
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: /sys/devices/pci0000:00/0000:00:1f.2/ata9/host8/target8:0:0/8:0:0:0
mdadm: scan: ptr->vendorID: 1103 __le16_to_cpu(ptr->deviceID): 2720
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: /sys/devices/pci0000:00/0000:00:1f.2/ata8/host7/target7:0:0/7:0:0:0
mdadm: scan: ptr->vendorID: 1103 __le16_to_cpu(ptr->deviceID): 2720
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: /sys/devices/pci0000:00/0000:00:1f.2/ata7/host6/target6:0:0/6:0:0:0
mdadm: scan: ptr->vendorID: 1103 __le16_to_cpu(ptr->deviceID): 2720
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: /sys/devices/pci0000:00/0000:00:1f.2/ata6/host5/target5:0:0/5:0:0:0
mdadm: scan: ptr->vendorID: 1103 __le16_to_cpu(ptr->deviceID): 2720
mdadm: path_attached_to_hba: hba: /sys/devices/pci0000:00/0000:00:1f.2 - 
disk: /sys/devices/pci0000:00/0000:00:1f.2/ata5/host4/target4:0:0/4:0:0:0
mdadm: scan: ptr->vendorID: 1103 __le16_to_cpu(ptr->deviceID): 2720

and now an attempt to --grow with --size max:

ganon mdadm-4.0 # ./mdadm --grow /dev/md128 --size max
mdadm: Grow_reshape: Cannot set device size in this type of array.

I am not using overlays with the above commands.
