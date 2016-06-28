From: Chris Murphy <lists@colorremedies.com>
Subject: Re: URE, link resets, user hostile defaults
Date: Tue, 28 Jun 2016 16:17:08 -0600
Message-ID: <CAJCQCtRaUtRwHr-K9Ns8E-YwmnJh4aSpHP9+0vnhEyMdokFDgw@mail.gmail.com>
References: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
 <57721A47.8070203@suse.de> <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
 <5772C1DE.9000403@turmel.org> <5772E210.4090007@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5772E210.4090007@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Phil Turmel <philip@turmel.org>, Chris Murphy <lists@colorremedies.com>, Hannes Reinecke <hare@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 28, 2016 at 2:46 PM, Wols Lists <antlists@youngman.org.uk> wrote:
> On 28/06/16 19:28, Phil Turmel wrote:
>> On 06/28/2016 01:33 PM, Chris Murphy wrote:
>>
>>> > Perhaps there's a better way to do this than change the default
>>> > timeout in the kernel? Maybe what we need is an upstream udev rule
>>> > that polls SCT ERC for each drive, and if it's
>>> > disabled/unsupported/unknown then it sets a much higher command timer
>>> > for that block device. And maybe it only does this on USB and SATA.
>>> > For anything enterprise or NAS grade, they do report (at least to
>>> > smartctl) SCT ERC in deciseconds. The most common value is 70
>>> > deciseconds, so a 30 second command timer is OK. Maybe it could even
>>> > be lower but that's a separate optimization conversation.
>> When Neil retired from maintainership, I mentioned that I would take a
>> stab at this.  You're right, just setting the kernel default timeout to
>> 180 would be a regression.  If I recall correctly, there are network
>> services that would disconnect if storage stacks could delay that long
>> before replying, whether good or bad.
>>
>> So a device discovery process that examines the drive's parameter pages
>> and makes an intelligent decision would be the way to go.  But as you
>> can see, I haven't dug into the ata & scsi layers to figure it out yet.
>>  It won't hurt my feelings if someone beats me to it.
>
> Talking off the top of my head :-) would it be possible to spawn a
> kernel thread - if it takes longer than an aggressive time-out - that
> just waits for far longer then rewrites it if the read finally completes?
>
> In other words, wait for say the 70 deciseconds, then spawn the rewrite
> thread, then continue waiting until whatever timeout. The thread could
> actually not even time out but just wait for the drive to time out. If
> the drive (eventually) responds rather than timing out then the rewrite
> would hopefully fix the potential impending URE.

I do not think the hang comes from the kernel, but from the drive
itself, during these deep recovery reads. I think the whole drive does
a big fat "look at the hand" while it deeply considers, many, many,
many thousands of times, how the F to recover this one goddamn sector.
And  until it recovers it (sometimes wrongly), or gives up and submits
a read error, the drive responds to nothing at all, is my
understanding. And hence why the hard resetting link ends up
happening.

If I'm right, threading this in the kernel won't help. It needs to be
threaded in the drive. And I'm also pretty sure that SAS drives have
command queue independence, don't have this problem, and can have
individual commands cancelled, where SATA is S.O.L.

Over on the Btrfs list someone wondered if this hang can just be
reinterpreted as always being the result of bad sectors, the kernel
knows what's pending in the drive command queue, resets the drive, and
pre-emptively reconstructs and overwrites every single LBA for every
command that was stuck in the queue. And I'm like, well that's not
very accurate is it?  That's like taking a baseball bat to a tick.
Assuming an unresponsive drive needs a pile of sectors overwritten
might actually piss off that drive, or its controller, and cause other
problems with the storage stack for all we know.

Anyway...


>
> So we'd need two timeouts really. Timeout 1 says "if it takes longer
> than this, do a background rewrite when it finally succeeds", and
> timeout 2 says "if it takes longer than this, return an error, but let
> the rewrite thread continue to wait".

The idea I had was similar, only applying to storage arrays where
there's redundancy. In that case, the first timeout is an
informational message what LBA range is experiencing a read delay. And
that would permit an upper layer to just preemptively overwrite those
slow LBAs.

This is bad though for the single drive use case, or even
linear/concat, and RAID 0 where the data on the slow sector really
must be read or you get EIO or whatever.

But this sort of work around requires lower layers knowing how the
upper layers are organized and I don't know there's a good way to work
that out.

I think we just poll the drive for SCT ERC and based on what comes
back, make a one size fits all decision for that block device. It can
hardly be much worse than now where "hard resetting link" doesn't
really stand out as an oh fuck moment. It just gets lost in other
kernel messages. At least by 180 seconds, there will be truth in
kernel messages that the drive is having read or write errors, even as
depending services are getting mad at all the delays. They're going to
get delayed anyway, just in a different way.


-- 
Chris Murphy
