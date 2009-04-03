From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: RAID5 volumes suddenly lost superblock and show weird hexdump patterns
Date: Sat, 04 Apr 2009 00:01:31 +0200
Message-ID: <878wmhieh0.fsf@frosties.localdomain>
References: <22849175.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22849175.post@talk.nabble.com> (estr4ng3d's message of "Thu, 2
	Apr 2009 07:25:57 -0700 (PDT)")
Sender: linux-raid-owner@vger.kernel.org
To: estr4ng3d <e5tr4ng3d@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

estr4ng3d <e5tr4ng3d@yahoo.com> writes:

> I got some of my RAID5 array volumes damaged. I have no idea what happened, I
> was simply trying to manually assemble them after a reboot, only to discover
> they are no longer recognized by mdadm as containing a superblock.
>
> What's interesting and really weird (to my humble knowledge at least) is
> that hexdumps show interesting patterns. http://pastebin.com/m494e69c0
> Obviously far from being random garbage (hence I'm ruling out media damage).
> Does RAID create this sort of data sequences as part of its operation? Could
> this have been deliberate overwriting of my volumes?
>
> I'm desperately trying to recover data on this array. Any help/pointers
> appreciated!
>
> Thanks

Looks more like you formated /dev/sda with ext2 instead of /dev/md0.

MfG
        Goswin
