From: Phil Turmel <philip@turmel.org>
Subject: Re: Failed Raid 5 due to OS mbr written on one of the array drives
Date: Tue, 3 Nov 2015 10:47:45 -0500
Message-ID: <5638D721.2050302@turmel.org>
References: <CAArDwD-7=Vmo16K3GH0dxZie=RAiSavZNfMNvabf4X6G4fK34w@mail.gmail.com>
 <5637A92B.5010305@turmel.org>
 <CAArDwD9SDbH-Xdi6hRciLcYkWzY+Kv3JtgtWCyvELffJ=gv+0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAArDwD9SDbH-Xdi6hRciLcYkWzY+Kv3JtgtWCyvELffJ=gv+0w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Tellier <telliern@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Nicolas,

{ Top posting repaired.  Please don't do that.  Convention on kernel.org
is reply-to-all, trim unnecessary quotes, and either bottom post or
interleave. }

On 11/03/2015 09:21 AM, Nicolas Tellier wrote:
> 2015-11-02 19:19 GMT+01:00 Phil Turmel <philip@turmel.org>:
>> Good afternoon Nicolas,

[trim /]

>>> Luckily I saved the original command used to create this array. Here
>>> is the one I think would be relevant in this case :
>>>
>>> mdadm --create --verbose --assume-clean /dev/md0 --level=5
>>> --metadata=1.2 --chunk=128 --raid-devices=4 /dev/sda1 /dev/sdb1
>>> /dev/sdc1 missing /dev/sdd
>>
>> 1) Leave off /dev/sdd
>> 2) Include --data-offset=262144

> Hi Phil, and thanks for taking the time to reply to me.
>
> I'm not sure I understood you advice correctly.
> When you say leave off /dev/sdd, do you mean I should recreate a 3
> disks array like this :
> mdadm --create --verbose --assume-clean /dev/md0 --level=5
> --metadata=1.2 --chunk=128 --data-offset=262144 --raid-devices=3
> /dev/sda1 /dev/sdb1 /dev/sdc1

No.

> Or a 4 disks array with no mention of /dev/sdd, like this (my instinct
> tell me that wouldn't work) :
> mdadm --create --verbose --assume-clean /dev/md0 --level=5
> --metadata=1.2 --chunk=128 --data-offset=262144 --raid-devices=4
> /dev/sda1 /dev/sdb1 /dev/sdc1

No, but closer.

> Or, as I was thinking originally, to put /dev/sdd as missing, like so:
> mdadm --create --verbose --assume-clean /dev/md0 --level=5
> --metadata=1.2 --chunk=128 --data-offset=262144 --raid-devices=4
> /dev/sda1 /dev/sdb1 /dev/sdc1 missing /dev/sdd

No.  The keyword "missing" takes the place of a device you don't want to
include:

mdadm --create --verbose --assume-clean /dev/md0 --level=5
--metadata=1.2 --chunk=128 --data-offset=262144 --raid-devices=4
/dev/sda1 /dev/sdb1 /dev/sdc1 missing

> In the eventuality of having to start back from scratch, I'll be sure
> to clean everything (zero-superblock and all) and check the health of
> all the devices. Raid 6 might be more suited to withstand some of my
> episodic stupidity :)

I recommend raid6 for all bulk storage arrays larger than 4T capacity,
unless the data can be easily reconstructed from other sources.

> I'm tempted to subscribe to the mailing list, but I'm afraid of the
> volume of e-mail I'm going to get. I originally tried to search
> through the archives, but couldn't find anything relevant to my case.
> I'm looking right now at the "timeout mismatch" results.

This list gets a few dozen emails a day, or less.  I use filtering tools
to put the mails into a dedicated folder, skipping my inbox.  (Unless
I'm named due to reply-to-all.)  That makes them easy to manage.

Please take the timeout mismatch problem seriously -- it breaks many
people's arrays.

Phil
