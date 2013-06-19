From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 growing interrupted, array won't assemble or resume growing
Date: Wed, 19 Jun 2013 14:36:52 -0400
Message-ID: <51C1FA44.1070306@turmel.org>
References: <CAGjXdAhMHEFFc1C0XUSY_K1ZxwaRG-x=NEw9H2Aiv+YtNat-tw@mail.gmail.com> <51B0C769.1070009@turmel.org> <CAGjXdAj+xsW=Ut9EUz65Ha_ZaGwgzJwRG6vh+9S60jpCK1qNpA@mail.gmail.com> <51B1D58A.3010309@turmel.org> <CAGjXdAjgRTho6r8EdM04wBNR90uvbt72cWmkNy9_AuEt-qi1hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGjXdAjgRTho6r8EdM04wBNR90uvbt72cWmkNy9_AuEt-qi1hw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nic Wolfe <nic@wolfeden.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/19/2013 02:21 AM, Nic Wolfe wrote:

>> Well, search the archive for terms like "scterc", "ure", and/or
>> "timeout".  You'll need to address the issue if you don't have
>> enterprise drives.
>>
> 
> [trim /]

You trimmed here...  Per the linked reports, you have this problem.

>> Drives with pending unrecoverable read errors won't make it through a
>> rebuild, but show "PASSED" to smart.  The details matter.

Drive /dev/sdc has pending relocations.  Those are bad sectors that need
to be rewritten to either fix them or relocate them.  You are unable to
do that with your raid card because /dev/sdc does not support error
recovery control.

In fact, only your /dev/sdd supports it, and as a desktop drive, it
defaults to "Off" on every power cycle.

[trim /]

> OK I have built a PC with properly supported hardware that I can now
> hook all my drives up to directly. Unfortunately because they were
> being managed by the RAID card before as single drive JBOD arrays they
> do not show up as md devices on the new PC, so I will have to attempt
> to get this array running on the old PC with the old RAID/JBOD setup.

Some raid cards use part of the drive space to write management data,
and show a smaller drive to the OS.  If this is your case, you can
manually set up device mapper to expose the smaller areas as devices,
and build the MD array from those.  Detailed information about your
device sizes with and without the raid card would be needed.

> On the new PC I can see the SMART info but since the drives will have
> to be managed by the RAID card anyway I'm not sure if it is prudent to
> mess with the settings. It does sound like a good idea to maybe
> increase the timeouts on the OS though ("echo 180
>> /sys/block/sd[bcdefg]/device/timeout"). And hopefully my problems
> were just power in the first place?

No.  /dev/sdc is your problem.  There might be more, but they aren't
exposed in SMART yet.

> In case it helps though:
> 
> sdb: http://pastebin.com/btrpcMF0
> sdc: http://pastebin.com/kdcrf9mY
> sdd: http://pastebin.com/S0nj9Ma9
> sde: http://pastebin.com/G3vUZf92
> sdf: http://pastebin.com/0P2LbDQq
> sdg: http://pastebin.com/8q4vuU1a

As noted above, you will not be able to use /dev/sdc with the raid card.
 You could try leaving it out and taking a backup with the degraded
array.  That is what I would recommend first.

> Finally, I don't actually necessarily need to finish the reshape; I
> just want to get the data off. Can I assemble the array as degraded
> and just copy the data to a new location without finishing the
> reshape? It seems that'd save a whole lot of writing and potential for
> problems. If I can get the data off I can then blank the old drives
> and start over properly without the sucky RAID card and with the
> proper smart/erc settings. If that's possible how would I go about
> doing that other than just trying to --assemble?

Second choice is to figure out the "dmsetup" details to run without the
raid card, set the driver timeouts to 180 for all but /dev/sdd.  Turn on
scterc for that one.  Then let MD assemble and continue.  And take your
backup.

Phil

