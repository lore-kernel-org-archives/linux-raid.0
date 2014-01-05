From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Looking for some advice on best way to identify drives / recover
 from issues
Date: Sun, 5 Jan 2014 10:05:14 -0800
Message-ID: <CAK2H+ee7Wq9BPvbqYbycUEMgvPAW4_NR9ANC2kQ9AnHrJYewJA@mail.gmail.com>
References: <CAJrqPH9FNtomPygu1XPm2VQpJg3MKX1zUPCt0AOnzQ4GO7YEEQ@mail.gmail.com>
	<CAK2H+ecnYpDbyqQrFZwmkL4F++iVwDvhfxNqxzWETbFtvXJqUg@mail.gmail.com>
	<CAJrqPH_oj63UE6=n8OQZmM+mynjpUojy+0VLcvFXTmCO_JmmMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJrqPH_oj63UE6=n8OQZmM+mynjpUojy+0VLcvFXTmCO_JmmMQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dylan Distasio <interzone@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jan 5, 2014 at 9:01 AM, Dylan Distasio <interzone@gmail.com> wrote:
>>
>> I'm reacting to nothing more than 20 drives, no documentation and beeping:
>>
>> 1) Are the beeps POST codes?
>>
>> http://www.computerhope.com/beep.htm
>
> No, I woke up to it beeping, but it POSTs fine.  I think the beeping
> was probably coming from the Highpoint card indicating array failure.
> It no longer beeps, but it also won't pick up any drives.

>
> The machine will boot fine from what I can see, but I am concerned
> with disconnecting some drives and letting it boot because it might
> result in a degraded array assembling simply because I did not
> reconnect the drives it was looking for when I remove the highpoint
> from the picture.

A couple of things. Again, I'm not an md expert so be careful, but
this is just informational:

1) You said you have a couple of RAIDs in this box but you didn't
describe them very completely. To the extent you can what are they?
Give all the info you can: RAID type, number of drives, which drives,
do the RAIDs use dev names (/dev/sda) or do you use UUIDs? What
controllers are connected to what RAIDs.

2) IMO if the machine is booting without picking up the drives
attached to the Highpoint then it would seem logical that you could
completely remove the Highpoint - actually take it out of the PCI slot
- and still boot the machine. If you can do that and get to a Linux
prompt then document and test what you have. After that's done and
someone more md knowledgeable checks in on what you are reporting then
you could look at the Highpoint drives and finally the Highpoint
controller.

Personally I wouldn't do anything in terms of assembling the RAID by
hand until I had LOTS of mdadm data (Examine & Detail analysis for all
drives and RAIDs) If you have another machine where you could test
drives then I suppose you could remove them one-at-a-time and run
smartstl on each one to determine if there's any obvious problem.

Good luck,
Mark
