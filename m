From: "NeilBrown" <neilb@suse.de>
Subject: Re: Missing md superblock on added devices after grow ...
Date: Sun, 24 May 2009 07:05:35 +1000 (EST)
Message-ID: <16efced97de975092f941a9a626d6f0d.squirrel@neil.brown.name>
References: <200905231703.03692.denrdc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200905231703.03692.denrdc@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: rdc <denrdc@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 24, 2009 1:03 am, rdc wrote:
> Yesterday i grew my 4*500GB raid5 array to 7*500GB. The reshape operation
> ended succesfully according to the logs :
>
> May 22 22:24:56 [kernel] md: md2: reshape done.
> May 22 22:24:56 [kernel] RAID5 conf printout:
> May 22 22:24:56 [kernel]  --- rd:7 wd:7
> May 22 22:24:56 [kernel]  disk 0, o:1, dev:dm-3
> May 22 22:24:56 [kernel]  disk 1, o:1, dev:dm-0
> May 22 22:24:56 [kernel]  disk 2, o:1, dev:dm-2
> May 22 22:24:56 [kernel]  disk 3, o:1, dev:dm-1
> May 22 22:24:56 [kernel]  disk 4, o:1, dev:dm-8
> May 22 22:24:56 [kernel]  disk 5, o:1, dev:dm-6
> May 22 22:24:56 [kernel]  disk 6, o:1, dev:dm-5

The devices in your array are dm-xx devices, but....

>
> However, upon restarting this morning the grown array was no longer
> detected,
> and my investigation revealed that the 3 device that were added do not
> contain
> an md superblock at all !
>
> One of the 3 new devices :
> mdadm --examine -v /dev/sdb1
> mdadm: No md superblock detected on /dev/sdb1.

... you are looking on sdxx devices for the superblock.  This
seem to me to be a strange thing to do.
What does
   mdadm --example /dev/mapper/whatever
show?

What exactly are the dm-xx devices?

NeilBrown


