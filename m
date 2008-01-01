From: "David Rees" <drees76@gmail.com>
Subject: Re: Last ditch plea on remote double raid5 disk failure
Date: Tue, 1 Jan 2008 01:56:00 -0800
Message-ID: <72dbd3150801010156l321424cbp1324d52e9cb8c0d0@mail.gmail.com>
References: <8e0f3ba80712310239w3263b2b8hb62c0a6c79a84b77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8e0f3ba80712310239w3263b2b8hb62c0a6c79a84b77@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <merlin@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Dec 31, 2007 2:39 AM, Marc MERLIN <merlin@gmail.com> wrote:
> new years eve :(  I was wondering if I can tell the kernel not to kick
> a drive out of an array if it sees a block error and just return the
> block error upstream, but continue otherwise (all my partitions are on
> a raid5 array, with lvm on top, so even if I were to lose a partition,
> I would still be likely to get the other ones back up if I can stop
> the auto kicking-out and killing the md array feature).

Best bet is to get a new drive into the machine that is at least the
same size as the bad-sector disk, use dd_rescue[1] to copy as much of
the bad-sector disk to the new one.

Remove the bad-sector disk, reboot and hopefully you'll have a
functioning raid array with a bit of bad data on it somewhere.

I'm probably missing a step somewhere but you get the general idea...

-Dave

[1] http://www.garloff.de/kurt/linux/ddrescue/
