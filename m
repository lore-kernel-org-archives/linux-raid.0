From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: new raid system for home use
Date: Mon, 19 Apr 2004 13:57:37 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0404191350310.12466-100000@coffee.psychology.mcmaster.ca>
References: <40839909.9080606@tequila.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40839909.9080606@tequila.co.jp>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> | think you need it?  volume managers are for people who want to divide
> | their storage into little chunks, and then experience the bofhish
> grandeur
> | of requiring the lusers to beg for more space.
> 
> There is no need for any kind of LVM unless you start with a small set
> of HDs and may need to extend it later without moving data around on
> partitions etc.
> for bofhish behavior there is quota ;)

yes, though I have to wonder whether there are performance implications
for doing that kind of incremental filesystem extension.  filesystems,
as you know, do normally want to have some knowlege of the "raid topology"
of the blockdev space they consume.

<scandalous>
personally, I kind of like the idea of having raid performed by the FS,
though this is obviously a steep undertaking (and undesirable in the 
complexity-management/layering/compartmentalization sense.)
</scandalous>

> software raid is more easy and cheap and faster, but I think in the
> upper area hardware raid has some other advantages, eg easy boot from
> raid 5, transparency to the OS layer (no 5 mds because you want
> partitions, no patches because you want to make md partitions, etc).
> 100% sure and easy hotswap ...

hw raid gives you an integrated solution.  you obviously wind up very very
dependent on replacement cards, firmware upgrades, the bios-level interface,
existence of any user-level control utilities, etc.

personally, I prefer to use commodity hardware in part because it's so
mundane.  how long will it take you to RMA that HW raid card?  if you're 
already paying for a big-name HW support contract, the time/money may be 
quite minimal.

regards, mark hahn.

