From: Oleg Drokin <green@namesys.com>
Subject: Re: How to get all disk geometry (logical/physical) equal for RAID5
Date: Sat, 7 Sep 2002 20:37:16 +0400
Message-ID: <20020907203716.B28312@namesys.com>
References: <200209071515.18103.Dieter.Nuetzel@hamburg.de> <200209071547.59386.Dieter.Nuetzel@hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <reiserfs-list-return-11396-reiserfs=m.gmane.org@namesys.com>
list-help: <mailto:reiserfs-list-help@namesys.com>
list-unsubscribe: <mailto:reiserfs-list-unsubscribe@namesys.com>
list-post: <mailto:reiserfs-list@namesys.com>
Errors-To: flx@namesys.com
Content-Disposition: inline
In-Reply-To: <200209071547.59386.Dieter.Nuetzel@hamburg.de>
To: Dieter N?tzel <Dieter.Nuetzel@hamburg.de>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Chris Mason <mason@suse.com>, Linux RAID List <linux-raid@vger.kernel.org>, ReiserFS List <reiserfs-list@namesys.com>
List-Id: linux-raid.ids

Hello!

On Sat, Sep 07, 2002 at 03:47:59PM +0200, Dieter N?tzel wrote:

> > hda (the spare) is on the on board VIA 686b controller and show some "bad"
> > logical numbers so that I get a different partition layout.

Different from what?
You can use dd to copy partition table with right layout.
Also 1st IDE disk is usually threated a bit different by partition code in order
to be compatible with BIOS boot logic. If that's your problem,
you can specify right geometry from "kernel command line" (append= in lilo)

> > Second to you and Chris:
> > Is it possible to boot from the mirrored RAID1 partitions (hdX10) with the
> > current lilo-22.x (SuSE 8.0)? With ReiserFS?

Should be no problem.
Lilo does not depend on filesystem at all, it only records disk block numbers.

It is unclear if you will be able to boot if first disk of mirrored set will
fail, because you usually have lilo only on one of the disks, but if lilo is
located on 3rd disk, then this will only work if you remove failed raid1 disk
and second disk will get same bios id as first one had. (note I am not quite
sure here, but it shold work this way. Also there might be a way to tell
lilo about RAID1 setups but I've never saw this myself).

> Is ReiserFS usable on such a system, too?

Reiserfs is usable on any block device that correctly works from reiserfs
perspective. (e.g. loop devices over samba do not work).

Bye,
    Oleg
