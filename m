From: Chris Murphy <lists@colorremedies.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Sun, 13 Jan 2013 20:58:48 -0700
Message-ID: <79F21812-2CA6-4A36-964A-8BF7667BC236@colorremedies.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301100349.46794.thomas@fjellstrom.ca> <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com> <201301110520.07128.thomas@fjellstrom.ca> <5C8F4DE0-5C1E-476F-BBA8-17A7D695E599@colorremedies.com> <3EE4457C-A185-4223-A84D-5BFBB204A94C@colorremedies.com> <50F0B2B7.1080604@turmel.org> <4424E5BF-CDA7-4888-8C0F-988D20D8C2F7@colorremedies.com> <50F33198.9060302@turmel.org> <9974543B-24D0-46E9-9852-09DE1C2F6D12@colorremedies.com> <50F3501B.30002@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F3501B.30002@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 13, 2013, at 5:23 PM, Phil Turmel <philip@turmel.org> wrote:

> On 01/13/2013 06:20 PM, Chris Murphy wrote:
>> 
>> On Jan 13, 2013, at 3:13 PM, Phil Turmel <philip@turmel.org> wrote:
>>> 
>>> I haven't examined the code in detail, just watched patches pass on
>>> the list.  :-)  But as I understand it, the error is returned with
>>> the request that it belongs to, and the MD does not look at the
>>> drive error code itself.  So MD know what read it was, for which
>>> member devices, but doesn't care if the error came from the drive
>>> itself, or the controller, or the driver.
>> 
>> I think it does, but I don't know diddly about the code.
> 
> If you think about this, you'll realize that the driver *must* keep
> track of every unique request for the block device.

Perhaps not. It looks like it's the SCSI layer that sets the timer on each request. The driver may be doing something comparatively simple. But in any case there is something in between the SATA controller and md that's tracking requests, yes. But presumably md tracks its own requests. It's expecting something back.


> Otherwise, how
> would MD know what data was read and ready to use?  And what data was
> written so its buffer could be freed?  Reads are distinct from writes.

Yes fine, and I'm suggesting timeouts are distinct from reads and writes. Read and write errors are drive reported errors. I'm suggesting there's some other error from either the linux block device driver (or the SCSI layer) that is not a read error or a write error, when there's a time out.

> 
>> Only the drive knows what LBA's exhibit read and write errors. The
>> linux driver doesn't. And the linux driver times out after 30 seconds
>> by default, which is an eternity. There isn't just one request
>> pending. There are dozens to hundreds of pending commands,
>> representing possibly tens of thousands of LBAs in the drive's own
>> cache.
> 
> But reads are separate from writes, and MD handles them differently.
> See the "md" man-page under "Recovery".

I know that. I'm just suggesting it's not only a read or write error that's possible.


> 
>> Once the drive goes into sector recovery, I'm pretty sure SATA
>> drives, unlike SAS, basically go silent. That's probably when the
>> linux timeout counter starts, in the meantime md is still talking to
>> the linux driver making more requests.
>> 
>> This is a huge pile of just requests, not even the data it
>> represents. Some of those requests made it to the drive, some are
>> with the linux driver. I think it's much easier/efficient, when linux
>> block device driver timeout arrives, for the linux driver to just
>> nullify all requests, gives the drive the boot (lalala i can't hear
>> you i don't care if you start talking to me again in 60 seconds), and
>> tells md with a single error that the drive isn't even available. And
>> I'd expect md does the only thing it can do if it gets such an error
>> which is the same as a write error; it flags the device in the array
>> as faulty. I'd be surprised if it tried to reconstruct data at all in
>> such a case, without an explicit read error and LBA reported by the
>> drive.
> 
> This is just wrong.

Yeah the last sentence is  clearly quite wrong: md has to reconstruct the data at some point in such a case, without an explicit read error from the drive. However, I think I largely had the idea right now that I've looked at this after-the-fact.

https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/task_controlling-scsi-command-timer-onlining-devices.html

I expect that the SCSI layer informs md that the device state is offline. And md in turn marks the drive faulty. And in turn rebuilds all pending and future data chunks for that device from parity (or mirrored copy). No need for a superfluous write attempt for an offline device.

>> 
>> Technically the spec statistic is "less than" 1 bit in 10^14 for a
>> consumer disk. So it's not that you will get a URE at 12TB, but that
>> you should be able to read at least 11.37TiB without a URE. It's
>> entirely within the tolerance if the mean occurrence happens 2 bits
>> shy of 10^15 bits, or 113TiB. By using "less than" the value is not a
>> mean. It's likely a lot higher than 12TB, or we'd have total mayhem
>> by now. That's only 3 reads of a 4TB drive otherwise. It's bad, but
>> not that bad.
> 
> That's not really how the statistics work.  The spec just means that if
> you run a typically drive for some long time on some workload you'll
> average one URE every 10^14 bits.

I don't accept this. "less than" cannot be redefined as "mean/average" in statistics.

And 1 bit does not equal an actual URE either. The drive either reports all 4096 bits for a sector (usually they are good, but they might be corrupted), or you get a URE in which case all 4096 bits are lost. There is no such thing as getting 1 bit of URE with a hard drive when the smallest unit is a sector containing 4096 bits (for non-AF drives).  4096 bits in 10^14 bits is *NOT* the same thing as 1 bit in 10^14 bits. If you lose a sector to URE in 12TBs, that's the same thing as 1 bit in 2.4^10.

And for an AF drive, a URE means you lose 16384 bits. If that happened every 12TB, it would be 1 bit in 6.1^9 bits of loss.

So I don't agree at all with the basic math you've proposed. But then again, I'm just an ape so someone probably ought to double check it.


>  What the actual shape of the
> distribution is varies through the life of the drive.  IIRC, Google's
> analysis was that the rate spikes early, then forms a gaussian
> distribution for the bulk of the life, then spikes again as mechanical
> parts wear out.

That was not a UBER/URE study however. That study was about failures, i.e. whole disks were replaced. They only looked at sector reallocation to see if there was correlation to drive failures/replacements, not if UBER was consistent with manufacturer's stated spec.


Chris Murphy

