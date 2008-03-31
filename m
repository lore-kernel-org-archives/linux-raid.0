From: "NeilBrown" <neilb@suse.de>
Subject: Re: Can't grow raid5 size
Date: Mon, 31 Mar 2008 22:22:18 +1100 (EST)
Message-ID: <53383.192.168.1.70.1206962538.squirrel@neil.brown.name>
References: <20080330200700.GA9285@csy.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080330200700.GA9285@csy.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Shane W <shane-kernel@csy.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, March 31, 2008 7:07 am, Shane W wrote:
> Hello all,
>
> I had a three drive raid5 array of 750GB drives.  Added a
> fourth drive and grew the array but the actual size didn't
> change.

The size wont change until it finishes restriping.  All the
data needs to be relocated before the new space is available.

What does "cat /proc/mdstat" show ??

>          Now when I do a mdadm --grow --size max /dev/md0,
> I get:
> mdadm: Cannot set device size/shape for /dev/md0: Device or
> resource busy

That is expected.  The array is busy restriping (aka reshaping).
You cannot change the size of individual devices at this time,
not that you really want to.



> Is there anything I can do to get the array to 2tb or do I
> need to recreate with a 1.x superblock format?

Using a different superblock format wouldn't help.

What is the current state of the array from /proc/mdstat?

NeilBrown

