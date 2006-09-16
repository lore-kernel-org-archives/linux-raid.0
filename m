From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: Please help me save my data
Date: Sat, 16 Sep 2006 15:14:01 +0200
Message-ID: <62b0912f0609160614x388afc61pc391029b91743d53@mail.gmail.com>
References: <59430.213.136.43.252.1157976989.squirrel@webmail.adocca.com>
	 <b53b67d20609110610v5d4a63a9ube77d918b0406484@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b53b67d20609110610v5d4a63a9ube77d918b0406484@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Hoover <phoover.eml@gmail.com>
Cc: linux-raid@vger.kernel.org, martin.kihlgren@adocca.com
List-Id: linux-raid.ids

Patrick Hoover wrote:
> Is anyone else having issues with USB interfaced disks to implement
> RAID? Any thoughts on Pros / Cons for doing this?

Sounds like a very good stress test for MD.

I often find servers completely hung when a disk fails, this usually
happens in the IDE layer.
If using USB disks circumvents the IDE layer enough, using USB disks
might get rid of these hangs.  Would be nice at least.  Maybe I'm just
dreaming.

For end users, USB might remove the need to take special care of
cooling in your cabinet.
OTOH, most USB disk enclosures have horrible thermal properties.

USB would make it a lot easier to add new disks (beyond your cabinet's
capacity) and to remove old disks when/if they're no longer needed.
Users might run into a bandwidth issue at some point..
