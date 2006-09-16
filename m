From: martin.kihlgren@adocca.com
Subject: Re: Please help me save my data
Date: Sun, 17 Sep 2006 01:53:37 +0200 (CEST)
Message-ID: <64788.81.216.197.117.1158450817.squirrel@webmail.adocca.com>
References: <59430.213.136.43.252.1157976989.squirrel@webmail.adocca.com>
    <b53b67d20609110610v5d4a63a9ube77d918b0406484@mail.gmail.com>
    <62b0912f0609160614x388afc61pc391029b91743d53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0609160614x388afc61pc391029b91743d53@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: Patrick Hoover <phoover.eml@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Patrick Hoover wrote:
>> Is anyone else having issues with USB interfaced disks to implement
>> RAID? Any thoughts on Pros / Cons for doing this?
>
> Sounds like a very good stress test for MD.
>
> I often find servers completely hung when a disk fails, this usually
> happens in the IDE layer.
> If using USB disks circumvents the IDE layer enough, using USB disks
> might get rid of these hangs.  Would be nice at least.  Maybe I'm just
> dreaming.
>
> For end users, USB might remove the need to take special care of
> cooling in your cabinet.
> OTOH, most USB disk enclosures have horrible thermal properties.
>
> USB would make it a lot easier to add new disks (beyond your cabinet's
> capacity) and to remove old disks when/if they're no longer needed.
> Users might run into a bandwidth issue at some point..

After I got rid of a crappy USB hub the catastrophic resets stopped. And
after I bought a separate PCI USB card the non-catastrophic resets have
almost stopped as well.

So now the system works as well as I hoped when I planned it!

And no, nothing hangs except the disk access to the device in question
when a disk fails.

My Seagate disks DO generate too much heat if I stack them on top of each
other, which their form factor suggests they would accept. If I put them a
bit more spacy though it works perfectly. And there ARE enclosures with
separate fans.

I have 10 external USB disks now - I got rid of my internal ones which
were too old and failing, and I plan on continuing to add on to my
external array. My RAID5 + LVM + dm_crypt + XFS setup allows for a very
extendable system.

And as long as I treat the entire disk set as one device, the bandwidth
will not be an issue since I will never demand more bandwidth from the
entire array than from a single USB drive anyway.

//Martin
