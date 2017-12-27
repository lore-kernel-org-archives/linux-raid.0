From: Phil Turmel <philip@turmel.org>
Subject: Re: 3-way mirror to RAID-6
Date: Wed, 27 Dec 2017 09:28:50 -0500
Message-ID: <063586b9-6b63-9afe-9edc-dd3a73adf1b4@turmel.org>
References: <CAJH6TXg=uCQMmzSQPHC885naZj3cFOZx2oyx462mCBof9NeU+w@mail.gmail.com>
 <87incu79uw.fsf@notabene.neil.brown.name>
 <CAJH6TXh_u08K+w-na_YQDh0WZWOQ8o14=SEzQmwPVrGPbkWasA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXh_u08K+w-na_YQDh0WZWOQ8o14=SEzQmwPVrGPbkWasA@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, NeilBrown <neilb@suse.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/27/2017 05:13 AM, Gandalf Corvotempesta wrote:
> 2017-12-25 22:53 GMT+01:00 NeilBrown <neilb@suse.com>:
>> I suggest you add the new device with "mdadm --add", then try the
>> reshape with "mdadm --grow /dev/mdXXX --level=6 --raid-devices-4".
> 
> Ok.

If that works, you're done.  But the designer of the code thinks it
won't, so don't hold your breath.

>> It might not work quite that easily - I think you need to first convert
>> the raid1 to a 2-way mirror, but that is easy enough
>>
>>  mdadm --grow /dev/mdxxx --raid-devices=2
> 
> Moving from a 3-way mirror to a 2-way mirror is not an issue.

I think you mean "is an issue" ....

> What do you suggest ? Adding 3 more disks and creating a striped 3-way
> mirror or reshaping to a 4-disks RAID-6?
> 
> Keep in mind that i'll never run anything with redundancy level < 2
> and a simple mirror has only "1" as redundancy level (a striped mirror
> is the same: only one disks could be lost in each mirror pair)

.... based on this requirement of yours.

You can't get there from here, at least not while running.  Converting
from raid1 n=2 to any parity-based layout takes advantage of the fact
that the data content of a simple mirror is identical to the data
content of a raid4/5 n=2, since parity of one bit is the same bit.

With some downtime, you could do the following:

1) Unmount and/or deactivate your array (but leave the array running).

2) Reduce your mirror from n=3 to n=2 and *remove* the newly spared
member -- holding it in reserve in case of disaster.

3) Add the new drive as a spare, then --grow to raid6 n=3.  *Wait* for
the reshape to complete (restoring your desired redundancy within the
array).

4) Remount or re-activate your array and resume normal operations.

5) Add the drive from (2) back as a spare (may have to
--zero-superblock) and reshape from raid6 n=3 to raid6 n=4.

There are no-downtime options possible if you have LVM on top of your
array, and if you can add at least a fifth drive to the mix.

Phil

5) Wi
