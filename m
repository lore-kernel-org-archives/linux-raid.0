From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: md questions [forward of Jims corrections]
Date: Fri, 23 Jan 2004 19:51:02 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401231951.02359.gene.heskett@verizon.net>
References: <200401221928.00985.gene.heskett@verizon.net> <200401231108.45177.jhines@wdtv.com>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200401231108.45177.jhines@wdtv.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
Cc: gene.heskett@verizon.net, Jim Hines <jhines@wdtv.com>
List-Id: linux-raid.ids

On Friday 23 January 2004 11:08, Jim Hines wrote:
>On Thursday 22 January 2004 07:28 pm, Gene Heskett wrote:
>> Last week, something went in the toilet on its boot drive running
>> ext3 and in the aftermath of an e2fsck everything was there, but
>> in the lost+found directory, so the machine was replaced with a
>> slightly newer one, the promise cards (20269's I think, but my
>> hand isn't anywhere near a bible) were moved in from the older
>> box, and the drives enhanced so there are now 4 each 180Gb drives
>> in the raid5 setup on those two promise cards, and a couple of the
>> older, still good 160Gbs for boot etc on the mobo's own
>> controller.
>
>Actually, the drives are in the following configuration: Four Maxtor
> 160mb drives, two Western Digital 180MB drives. The Four Maxtors
> are connected to the two Promise 20269 cards, while the WDs are
> connected to the motherboards Highpoint technologies HP370 RAID
> controller, but NOT in hardware RAID mode.
>
>> But, on the restart, with nothing other than the filesystem
>> installed on the 'md' drives, it gave us a resync time of about
>> 29,000 seconds. We cannot even see why a resync should be running
>> since the array was at that point empty.  This was 2 days ago, and
>> I've been informed that allthough the recovered crontab scripts
>> seem to be working, the write speeds are atrocious, something like
>> 16kb/second.  hdparm OTOH, reports the read times to be quite
>> respectable and in the 160Mb/sec area.
>
>The really strange thing is, it starts doing a resync immediatly
> after doing a mkraid /dev/md0.....before the drives have even been
> formatted (to reiserfs for ext3). I then format the drives, and the
> resync continues (I have also tried the newer mdadm tools, with the
> same results).
>
>It finished the resync yesterday, and I have been doing backups, but
> the write times are incredibly slow. One server has been running
> the backup now for over 12hrs and has only gathered about 7 of 66gb
> on the RAID server.
>
>> Also, and not sure if there is any connection, adding a 3rd
>> promise card seems to do a fine job of fscking up the drive
>> scanning during post.  Jim, haveing those 180's laying around,
>> wanted to setup a second md array of 2 of them running in mirror
>> mode in that machine, but thats apparently not possible.  It
>> (post) seems to find several more drives than actually exist, but
>> none appear to be accessable after post.
>
>I gave up on the third Promise card, it is either causing problems
> with the bus, or with the BIOS, so it's gone in favor of the HP370
> motherboard RAID for the two 160s.
>
>> Recommendations?  Things to check?  We're idiots?
>
>Idiots!? Hey! Speak for yourself   ;)
>
>
>Thanks,

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty: soap,
ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
99.22% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2004 by Maurice Eugene Heskett, all rights reserved.
