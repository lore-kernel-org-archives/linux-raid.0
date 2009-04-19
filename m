From: "NeilBrown" <neilb@suse.de>
Subject: Re: RAID without superblock
Date: Mon, 20 Apr 2009 06:44:17 +1000 (EST)
Message-ID: <e96b335a0ba8595e2921d164f9b15ff7.squirrel@neil.brown.name>
References: <20090419114743.GA29195@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090419114743.GA29195@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, April 19, 2009 9:47 pm, Piergiorgio Sartor wrote:
> Hi all,
>
> what is the proper way to assemble a two disk,
> RAID-1, without superblock.
> That is, created with "-B" instead of "-C".

Why would you want a RAID-1 without superblock. I generally
consider that a legacy configuration.

>
> I noticed that re-using "-B", will start an
> array sync/repair, but it is not clear to me
> which disk is source and which is destination.

As there is no superblock, md cannot tell if the array is "clean"
or not.  It assumes the worst.
If you know for a fact that the two mirrors are consistent,
then tell mdadm with "--assume-clean".


>
> Using a bitmap file, seems to be safer option,
> but I'm not sure if this is just a workaround
> or it is the proper way.

A bitmap (which has to be in a separate file) can be use
to record the clean/dirty status.  It provides some of the same
functionality as a superblock.  But it is not a complete replacement.

To quote from the man page:

        Because of this, the Build mode should only be used
        together with a complete understanding of what you are doing.

NeilBrown

