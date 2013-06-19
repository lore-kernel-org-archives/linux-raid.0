From: Nic Wolfe <nic@wolfeden.ca>
Subject: Re: RAID6 growing interrupted, array won't assemble or resume growing
Date: Wed, 19 Jun 2013 00:21:03 -0600
Message-ID: <CAGjXdAjgRTho6r8EdM04wBNR90uvbt72cWmkNy9_AuEt-qi1hw@mail.gmail.com>
References: <CAGjXdAhMHEFFc1C0XUSY_K1ZxwaRG-x=NEw9H2Aiv+YtNat-tw@mail.gmail.com>
	<51B0C769.1070009@turmel.org>
	<CAGjXdAj+xsW=Ut9EUz65Ha_ZaGwgzJwRG6vh+9S60jpCK1qNpA@mail.gmail.com>
	<51B1D58A.3010309@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51B1D58A.3010309@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Before you move drives around, please spend some time correlating drive
> serial numbers to the "RaidDevice" number for each.  Just in case.  You
> may be able to get everything you need from /dev/disk/by-id/, but with a
> weird driver, I not sure.
>

Done, thanks.

>
> Well, search the archive for terms like "scterc", "ure", and/or
> "timeout".  You'll need to address the issue if you don't have
> enterprise drives.
>

[trim /]

>
> Drives with pending unrecoverable read errors won't make it through a
> rebuild, but show "PASSED" to smart.  The details matter.
>
>> I am not having hardware problems at the moment, I only encountered
>> them when I had 16 drives running through the RAID card (I have
>> another 10 drive array). With the other array disconnected the card
>> seems to be behaving - there's nothing suspicious that I can see in
>> dmesg.
>
> That sounds like insufficient power.
>
>> In the meantime I will see if I can put together a machine with 6 SATA
>> ports and attempt to hook the drives up directly rather than through
>> the RAID card so I can use a live CD and get the SMART information for
>> you.
>
> Good plan, but do get the serial numbers vs. array role info.  Probably
> should finish the reshape in such a machine, too.

OK I have built a PC with properly supported hardware that I can now
hook all my drives up to directly. Unfortunately because they were
being managed by the RAID card before as single drive JBOD arrays they
do not show up as md devices on the new PC, so I will have to attempt
to get this array running on the old PC with the old RAID/JBOD setup.

On the new PC I can see the SMART info but since the drives will have
to be managed by the RAID card anyway I'm not sure if it is prudent to
mess with the settings. It does sound like a good idea to maybe
increase the timeouts on the OS though ("echo 180
>/sys/block/sd[bcdefg]/device/timeout"). And hopefully my problems
were just power in the first place?

In case it helps though:

sdb: http://pastebin.com/btrpcMF0
sdc: http://pastebin.com/kdcrf9mY
sdd: http://pastebin.com/S0nj9Ma9
sde: http://pastebin.com/G3vUZf92
sdf: http://pastebin.com/0P2LbDQq
sdg: http://pastebin.com/8q4vuU1a

Finally, I don't actually necessarily need to finish the reshape; I
just want to get the data off. Can I assemble the array as degraded
and just copy the data to a new location without finishing the
reshape? It seems that'd save a whole lot of writing and potential for
problems. If I can get the data off I can then blank the old drives
and start over properly without the sucky RAID card and with the
proper smart/erc settings. If that's possible how would I go about
doing that other than just trying to --assemble?

Thanks,

Nic
