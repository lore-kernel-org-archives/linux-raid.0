From: "NeilBrown" <neilb@suse.de>
Subject: Re: RAID-6 mdadm disks out of sync issue (long e-mail)
Date: Wed, 10 Jun 2009 20:55:19 +1000 (EST)
Message-ID: <ed308b763e18e168a98f977857663bed.squirrel@neil.brown.name>
References: <S1752989AbZFJCy5/20090610025457Z+40@vger.kernel.org>
    <200906100852.n5A8qPbB034265@cjb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200906100852.n5A8qPbB034265@cjb.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid.vger.kernel.org@atu.cjb.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, June 10, 2009 6:52 pm, linux-raid.vger.kernel.org@atu.cjb.net wrote:
>
> Hello Linux-RAID mailing list.
>
> Any help from those with more knowledge than myself would
> be greatly appreciated.

I strongly suspect that you can get all your data back.

The arrays are not currently active (/proc/mdstat shows "inactive")
so nothing is going to write to them.  You can reboot without any
concern on that point.

Your priority has to be to sort out the read errors on those drives.
Whether you have to change cables or controller or whatever, and
reboot as often as you like: just get the drives in a state where
you can reliably read from them.  Don't perform any further mdadm
commands until you have achieved that.

Once you are sure you have the 6 drives with the highest event counts
working, assemble them with
   mdadm --assemble /dev/md13 --force /dev/sd?1

and you will almost certainly have a working (though degraded) array.
Then, if you are confident that the other drives are working, add
them with
   mdadm /dev/md13 --add /dev/sdwhatever

Good luck.

NeilBrown

