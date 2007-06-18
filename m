From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Machine hanging on synchronize cache on shutdown 2.6.22-rc4-git[45678]
Date: Mon, 18 Jun 2007 15:40:55 +0400
Message-ID: <46766F47.1080405@wasp.net.au>
References: <200706181129.l5IBT0Sa002063@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200706181129.l5IBT0Sa002063@harpo.it.uu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: htejun@gmail.com, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Pettersson wrote:

>>> I don't think sata_promise is the guilty party here. Looks like some
>>> layer above sata_promise got confused about the state of the interface.
>> But locking up hard after hardreset is a problem of sata_promise, no?
> 
> Maybe, maybe not. The original report doesn't specify where/how
> the machine hung.

It hangs in the process of trying to power it off. Unmount everything and halt the machine.

I've tried halt with and without the -h.

With the -h you can hear the drives spin down, then it tries to spin them up again and hangs.

Without the -h it just hangs hard where you see in the photo.

> Brad: can you enable sysrq and check if the kernel responds to
> sysrq when it appears to hang, and if so, where it's executing?

All my kernels have sysrq enabled. Once the hard reset is displayed on the screen everything locks.

> sata_promise just passes sata_std_hardreset to ata_do_eh.
> I've certainly seen EH hardresets work before, so I'm assuming
> that something in this particular situation (PHY offlined,
> kernel close to shutting down) breaks things.

That is my thought. I thought on a .22-rc kernel if I used halt -h and it spun the disks down that 
the kernel would detect that and not try to flush the caches on them, or have I read something 
incorrectly?

> FWIW, I'm seeing scsi layer accesses (cache flushes) after things
> like rmmod sata_promise. They error out and don't seem to cause
> any harm, but the fact that they occur at all makes me nervous.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
