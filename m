From: Phil Turmel <philip@turmel.org>
Subject: Re: Advice requested re: hard drive setup for RAID arrays
Date: Wed, 4 Nov 2015 08:13:06 -0500
Message-ID: <563A0462.9000200@turmel.org>
References: <CAPpdf595q7qsU-3e4rm_9qKKdoOzZi6mVTtrr=Hczqk=UsNf5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf595q7qsU-3e4rm_9qKKdoOzZi6mVTtrr=Hczqk=UsNf5Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>, Brad Campbell <lists2009@fnarfbargle.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good morning Dee, Brad,

On 11/04/2015 07:02 AM, o1bigtenor wrote:
> On Tue, Nov 3, 2015 at 10:31 PM, Brad Campbell

>> Here's how I do it. This script is run on every bootup.

A few notes here for Dee:

Running this script (or something similar) needs to be automatic.  In
older systems, that means including it in /etc/rc.local.  That file is
deprecated in some modern systems, and alternates vary by distro.  I
don't know what you should use in Debian 8.  {It still exists and works
in Ubuntu Server 14.04.}

>> It iterates through all the drives and uses smartctl to try and set erc
>> timeouts. If that fails it assumes the drive does not support it and it sets
>> the timeout value to 180 seconds.
>>
>> #!/bin/bash
>> for i in /dev/sd? ; do

This iterates through all sata drives, whether raid or not.

>>         if smartctl -l scterc,70,70 $i > /dev/null ; then
>>                 echo -n $i " is good "

"Good" clearly means the device has ERC support and the default timeout
is OK.

>>         else
>>                 echo 180 > /sys/block/${i/\/dev\/}/device/timeout
>>                 echo -n $i " is  bad "

"Bad" means it doesn't support ERC, so the timeout is set to the
work-around 180 seconds.  That's the best you can do for such drives.

>>         fi;
>>         smartctl -i $i | egrep "(Device Model|Product:)"

Your output was scrambled a bit at the end because a couple devices
didn't report model or product, which Brad relied on for a end-of-line
character.

>>         blockdev --setra 1024 $i
>> done
>>
>> I have a mix of 15k SAS drives, WD green & red and some left over bits and
>> pieces. This ensures the timeouts all match the drives capability.

Looks pretty good to me.

> ran the script

> /dev/sda  is  bad Device Model:     ST1000DM003-1ER162
> /dev/sdb  is good Device Model:     ST31000524AS
> /dev/sdc  is  bad Device Model:     ST1000DM003-1ER162
> /dev/sdd  is  bad Device Model:     Corsair Force 3 SSD
> /dev/sde  is good Device Model:     ST31000524AS
> /dev/sdf  is good Device Model:     ST31000524AS
> /dev/sdg  is  bad /dev/sdh  is  bad

> As sdh is supposed to be a NAS drive I'm now confused.

The script doesn't care what the drives are used for -- it just picked
out all that start with 'sd'.

> Is there anything that can be done to the drives already owned?

Already done by the script.  Not ideal, but not catastrophic.

> How does one find applicable hard drives?
> Only buy Enterprise class drives?

{ This was in your reading assignments.  You may need to re-read them. I
suggest you subscribe to this list -- let the normal flow of questions
and answers help teach you the concepts underneath all of this advice.
Anyways, }

Buy drives that clearly indicate 'raid' or 'enterprise' support, or have
OEM datasheets that explicitly show ERC support.

My latest purchases have been Western Digital "Red" drives.  They are
marketed to home & small business NAS applications.  I'm sure other
brands are now targeting that market, too.

Phil

