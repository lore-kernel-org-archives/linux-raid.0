From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Disk Monitoring
Date: Wed, 28 Jun 2017 13:43:56 +0100
Message-ID: <5953A48C.9080500@youngman.org.uk>
References: <CAJH6TXgvrVckHDmh1oiN9mupLrsS2NP3J44bG1_wE9Nnx4=yHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXgvrVckHDmh1oiN9mupLrsS2NP3J44bG1_wE9Nnx4=yHQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/06/17 11:25, Gandalf Corvotempesta wrote:
> Hi to all
> I always used hardwre raid but with my next server I would like to use mdadm.
> 
> Some questions:
> 
> 1) all raid controllers have proactive monitoring features, like
> patrol read, consistency check and (more or less) some SMART
> integration.
> Any counterpart in mdadm?
> 
> 2) thanks to this features, raid controller are usually able to detect
> disk issues before they cause data-loss. what about mdadm ?
> 
> How and when do you replace disks ? Based on which params? Do you
> always wait for a total failure before replacing the disk?

Not wise. mdadm has the --replace option which will copy a failing
drive. This ensures redundancy is not lost during a disk replacement
(unless other stuff goes wrong too).

You need to use stuff like SMART to monitor disk health, read up on
smartctl. Okay, disks often fail unexpectedly even when SMART says
they're healthy, but if things like the relocate count start climbing
it's an indication of trouble ...

Some people are very aggressive and replace disks at the first hint of
trouble. Other people only replace disks when things start going badly
wrong. Your call. The whole point of raid is to enable recovery when
things have otherwise gone irretrievably wrong, but it's best not to
push your luck that far as many people have found out ...
> 
> Is mdadm able to notify some possible bad-things before they happens ?

You probably need to turn on kernel logging. And monitor the logs!

Also keep an eye on /proc/mdstat.

I don't know what state xosview is in at the moment but that's my
favourite monitoring tool. Run it on the server with the array, use X to
display it on your local desktop. Last I checked, the raid monitoring
stuff was broken, but the author knows and was fixing it.
> 
> Many times in the past our raid controllers forced a bad sector
> reallocation during proactive tasks like patrol read. This saved me
> many times before. I've tried to not replace a disks when this
> reallocation was made (it was a test server) and after some weeks the
> disk failed totally.

Read up on how disks fail. If you tell mdadm to do a "scrub" it will
read the array from end to end. This should cause any dodgy sectors to
be rewritten. Note that this doesn't mean anything is wrong - just as
RAM decays and needs to be refreshed every few nanoseconds, so disk
decays and needs to be refreshed every few years. It's only when the
magnetic coating begins to physically decay that you need to worry about
the health of the disk on that score.

Cheers,
Wol

