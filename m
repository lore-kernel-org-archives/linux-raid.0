From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Advice requested re: hard drive setup for RAID arrays
Date: Wed, 4 Nov 2015 06:02:01 -0600
Message-ID: <CAPpdf595q7qsU-3e4rm_9qKKdoOzZi6mVTtrr=Hczqk=UsNf5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 3, 2015 at 10:31 PM, Brad Campbell
<lists2009@fnarfbargle.com> wrote:
> On 04/11/15 12:05, o1bigtenor wrote:
>>
>> On Tue, Nov 3, 2015 at 10:01 PM, o1bigtenor <o1bigtenor@gmail.com> wrote:
>>>
>>>
>>>
>>>
>>> On Tue, Nov 3, 2015 at 10:08 AM, Phil Turmel <philip@turmel.org> wrote:
>>>>
>>>> One caveat -- don't do this part until you've corrected your timeout
>>>> mismatch
>>>> problem, or any latent UREs will break your array again.
>>>
>>>
>>>
>>>
>>> Read through the references.
>>>
>>> How do I do what you suggest?
>
>
> Here's how I do it. This script is run on every bootup.
>
> It iterates through all the drives and uses smartctl to try and set erc
> timeouts. If that fails it assumes the drive does not support it and it sets
> the timeout value to 180 seconds.
>
> #!/bin/bash
> for i in /dev/sd? ; do
>         if smartctl -l scterc,70,70 $i > /dev/null ; then
>                 echo -n $i " is good "
>         else
>                 echo 180 > /sys/block/${i/\/dev\/}/device/timeout
>                 echo -n $i " is  bad "
>         fi;
>         smartctl -i $i | egrep "(Device Model|Product:)"
>         blockdev --setra 1024 $i
> done
>
> I have a mix of 15k SAS drives, WD green & red and some left over bits and
> pieces. This ensures the timeouts all match the drives capability.
>
ran the script

root@debianbase:/# !/bin/bash
bash: !/bin/bash: event not found
root@debianbase:/# for i in /dev/sd? ; do
>         if smartctl -l scterc,70,70 $i > /dev/null ; then
>                 echo -n $i " is good "
>         else
>                 echo 180 > /sys/block/${i/\/dev\/}/device/timeout
>                 echo -n $i " is  bad "
>         fi;
>         smartctl -i $i | egrep "(Device Model|Product:)"
>         blockdev --setra 1024 $i
> done
/dev/sda  is  bad Device Model:     ST1000DM003-1ER162
/dev/sdb  is good Device Model:     ST31000524AS
/dev/sdc  is  bad Device Model:     ST1000DM003-1ER162
/dev/sdd  is  bad Device Model:     Corsair Force 3 SSD
/dev/sde  is good Device Model:     ST31000524AS
/dev/sdf  is good Device Model:     ST31000524AS
/dev/sdg  is  bad /dev/sdh  is  bad root@debianbase:/#


As sdh is supposed to be a NAS drive I'm now confused.

Is there anything that can be done to the drives already owned?

How does one find applicable hard drives?
Only buy Enterprise class drives?



> Regards,
> Brad
