From: Phil Turmel <philip@turmel.org>
Subject: Re: Trouble adding disk to degraded array
Date: Wed, 09 Jan 2013 16:54:04 -0500
Message-ID: <50EDE6FC.1060403@turmel.org>
References: <CAJ=LqmbYG8H45M196ZuRcDMu9Ucz0t_pQenQbZtMKM9AhSqrpQ@mail.gmail.com> <CAJ=LqmasSo9WRmPAO6-RBE5N=zxg9vitWhdqcekbUO89oxKevA@mail.gmail.com> <50EDAF0A.7030903@turmel.org> <CAJ=LqmbKR1BczeFyGeQooDsPMf8PqriiD3z7i1_LjupGij5ewQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ=LqmbKR1BczeFyGeQooDsPMf8PqriiD3z7i1_LjupGij5ewQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Nicholas Ipsen(Sephiroth_VII)" <sephiroth7vii@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Nicholas,

[Top-posting fixed.  Please don't do that.]

On 01/09/2013 04:18 PM, Nicholas Ipsen(Sephiroth_VII) wrote:
> On 9 January 2013 18:55, Phil Turmel <philip@turmel.org> wrote:
>> On 01/09/2013 12:21 PM, Nicholas Ipsen(Sephiroth_VII) wrote:
>>> I recently had mdadm mark a disk in my RAID5-array as faulty. As it
>>> was within warranty, I returned it to the manufacturer, and have now
>>> installed a new drive. However, when I try to add it, recovery fails
>>> about halfway through,  with the newly added drive being marked as a
>>> spare, and one of my other drives marked as faulty!
>>>
>>> I seem to have full access to my data when assembling the array
>>> without the new disk using --force, and e2fsck reports no problems
>>> with the filesystem.
>>>
>>> What is happening here?
>>
>> You haven't offered a great deal of information here, so I'll speculate:
>>  an unused sector one of your original drives has become unreadable (per
>> most drive specs, occurs naturally about every 12TB read).  Since
>> rebuilding an array involves computing parity for every stripe, the
>> unused sector is read and triggers the unrecoverable read error (URE).
>> Since the rebuild is incomplete, mdadm has no way to generate this
>> sector from another source, and doesn't know it isn't used, so the drive
>> is kicked out of the array.  You now have a double-degraded raid5, which
>> cannot continue operating.
>>
>> If you post the output of dmesg, "mdadm -D /dev/mdX", and "mdadm -E
>> /dev/sd[a-z]" (the latter with the appropriate member devices), we can
>> be more specific.
>>
>> BTW, this exact scenario is why raid6 is so popular, and why weekly
>> scrubbing is vital.
>>
>> It's also possible that you are experiencing the side effects of an
>> error timeout mismatch between your drives (defaults vary) and the linux
>> driver stack (default 30s).  Drive timeout must be less than the driver
>> timeout, or good drives will eventually be kicked out of your array.
>> Enterprise drives default to 7 seconds.  Desktop drives all default to
>> more than 60 seconds, and it seems most will spend up to 120 seconds.
>>
>> Cheap desktop drives cannot change their timeout.  For those, you must
>> change the driver timeout with:
>>
>> echo 120 >/sys/block/sdX/device/timeout
>>
>> Better desktop drives will allow you to set a 7 second timeout with:
>>
>> smartctl -l scterc,70,70 /dev/sdX
>>
>> Either solution must be executed on each boot, or drive hot-swap.

> Hello Phil, thank you for your prompt reply. It's the first time I've
> done any serious debugging work on mdadm, so please excuse my
> inadequacies. I've attached the files you requested. If you could
> please look through them and offer your thoughts, it'd be most
> appreciated.

I've looked at your dmesg, and it confirms that you had an unrecoverable
read error on /dev/sdc1. The attachment that was supposed to be the
output of "mdadm -E /dev/sd[abcde]1" was something else, but no big
deal.  (Partition #1 is the array member, not the whole drive.)

(You can put such things directly in the email in the future--easier to
read.)

At this point, you could try to re-write the sectors on /dev/sdc that
are currently unreadable, to get them to relocate.  But I'd recommend
using the spare with dd_rescue to copy everything readable from
/dev/sdc.  (With the array stopped.)

Then you can zero the superblock on /dev/sdc1, leave the copy in place,
and restart the array with the copy.  Then add sdc1 to the array, and
let mdadm rebuild (*to* sdc, instead of *from* sdc).

This plan does depend on the problem with sdc being transient.  Many
UREs are, and are fixed by writing over them.  Please show the output of:

smartctl -x /dev/sdc

Phil
