From: Andrew Burgess <aab@cichlid.com>
Subject: Re: RAID5 problem
Date: Sun, 4 Dec 2005 13:28:58 -0800
Message-ID: <200512042128.jB4LSwef010890@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

>I get tons of read errors of the type "(Attempt to read block from 
>filesystem resulted in short read)"

No errors in /var/log/messages?

>mdadm -S /dev/md0
>mdadm --create /dev/md0 -c32 -l5 -n4 missing /dev/hdc3 /dev/hde3 /dev/hdg3

>mdadm: /dev/hdc3 appears to be part of a raid array:
>     level=5 devices=4 ctime=Fri May 30 14:25:47 2003
>mdadm: /dev/hde3 appears to be part of a raid array:
>     level=5 devices=4 ctime=Fri May 30 14:25:47 2003
>mdadm: /dev/hdg3 appears to contain an ext2fs file system
>     size=493736704K  mtime=Tue Jan  3 04:48:21 2006
>mdadm: /dev/hdg3 appears to be part of a raid array:
>     level=5 devices=4 ctime=Fri May 30 14:25:47 2003
>Continue creating array? no
>mdadm: create aborted.

>I aborted the above because it look strange to me that /dev/hdg3 appears 
>two times and /dev/hda3 doesn't at all!?!

You didn't specify hda3 in the command line. If you say 'create' and gives
devices then mdadm doesn't search for additional devices or look in
mdadm.conf.

hdg3 appears twice because mdadm has two different things to say about it.
It looks like an ext2 file system because that's where the ext2 indentifing
data for the raid device just happened to be.

>So this is where I got stuck, any help appreciated!

HTH

PS to Neil. I thought I might submit a patch to you that added a little 
more info the the above lines, the slot number and the raid device

So it would read:

mdadm: /dev/hdc3 appears to be part of a raid array:
     /dev/md0 slot[1] level=5 devices=4 ctime=Fri May 30 14:25:47 2003

I find this to be information that I have to search for using 'mdadm -E' so it
would be handy to see it all at once when having to force a broken array to
assemble.

Also it would be handy to see the update time rather than the creation time
(IMHO) so I can see how far apart the devices are (or maybe the event count
would be better for this) and whether or not the device was marked 'clean'.

What do you think?

Thanks!

