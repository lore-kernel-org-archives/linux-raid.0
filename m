From: Phil Turmel <philip@turmel.org>
Subject: Re: help recovering a software raid5 device
Date: Mon, 28 Jan 2013 09:56:41 -0500
Message-ID: <510691A9.4060403@turmel.org>
References: <CAAXKdzzERB_zzcdPPzuwdL+afFO334X3bck1EvrRV5rFvEEg6Q@mail.gmail.com> <5105D435.8090401@turmel.org> <CAAXKdzzajcx5Ee83fLo1bUbj8hYRh0aqJMcZykNHdgoUtLBkDg@mail.gmail.com> <5106810C.9090406@turmel.org> <CAAXKdzzS4MqhyvDxoJiFTe+BMdNFN+6VuPD=LpuKT5LO_nxoPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAXKdzzS4MqhyvDxoJiFTe+BMdNFN+6VuPD=LpuKT5LO_nxoPg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Theo Cabrerizo Diem <diem@carpediem.sh>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/28/2013 09:33 AM, Theo Cabrerizo Diem wrote:

[trim /]

> Is there a way that I could flag the raid device (or the partitions)
> to not be auto-detected on boot ? I'm afraid that since the "mdadm
> --create --assume-clean" completed successfuly before, a reboot on
> this machine might bring the array fully online and, for example,
> might trigger a check or resync of data. That would be the worse case.

You would modify your mdadm.conf file per its man-page to not allow
automatic assembly, then update your initramfs.  Both of these tasks
vary by distro.

[trim /]

>> So your copy of mdadm is very new, and has the new defaults for data
>> offset (leaving more room for a bad block log).  You need to boot with a
>> slightly older liveCD or other rescue media to get a copy of mdadm that
>> is about 1 year old.  Re-run the "mdadm --create --assume-clean" with
>> that version of mdadm.
>>
>> (The development version of mdadm has command-line syntax to set the
>> data offset per device, but I don't believe it has been released yet.
>> If you are comfortable using git and compiling your own utility, that
>> would be another option.)
>>
> I have no problem compiling the tools myself. I would actually prefer
> that than triggering a reboot on the machine and having unpredictable
> results from how it would be detected after the multiple attempts to
> create the device.
> 
> Is only the userspace tool required for this update or should I build
> also the kernel module too ?

Just the userspace tool.

> Is there any means that would prevent the "mdadm --scan ..." usually
> on ramdisks or init scripts for touching my array ? (i.e changing the
> partition types, for example ? )

Just the mdadm.conf file that ends up in the initramfs.

> I'm using WD Caviar Green disks, which are "cheap desktop drives" :).
> It is a home setup after all :( . I did got some WD "Red" series which
> supposedly have a "NAS friendly" firmware. Will gladly report back if
> those support SCTERC. They are less than 10% more expensive nowadays
> than the "Green" series.

Yes, the Red drives are reported to support SCTERC.  You could modify
the script to cover both cases:

> #! /bin/bash
> # Place in rc.local or wherever your distro expects boot-time scripts
> #
> for x in sdg sdh sdi sdj
> do
>     smartctl -l scterc,70,70 /dev/$x &>/dev/null || \
>     echo 180 >/sys/block/$x/device/timeout
> done

Drives that don't accept the seven-second timeout will be given a long
driver timeout.

[trim /]

> Once all this is solved, I would be more than happy to submit changes
> to the current wiki page containing the additional information you
> have been providing me that doesn't exists there, including pushing
> the timeout to a long one.

Please do.  And also strongly recommend people ask for help on this list
if they are the least bit hesitant.

Phil

