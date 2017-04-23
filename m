From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 15:16:05 +0200
Message-ID: <20170423131605.GA9955@metamorpher.de>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
 <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
 <20170423104606.GA4603@metamorpher.de>
 <754209bb-9990-2a36-2233-d7d1273c8e37@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <754209bb-9990-2a36-2233-d7d1273c8e37@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 23, 2017 at 01:12:54PM +0200, Patrik Dahlström wrote:
> I got some of that!

> [    3.100700] RAID conf printout:
> [    3.100700]  --- level:5 rd:5 wd:5
> [    3.100700]  disk 0, o:1, dev:sda
> [    3.100700]  disk 1, o:1, dev:sdb
> [    3.100701]  disk 2, o:1, dev:sdd
> [    3.100701]  disk 3, o:1, dev:sdc
> [    3.100701]  disk 4, o:1, dev:sde
> [    3.101006] created bitmap (44 pages) for device md1
> [    3.102245] md1: bitmap initialized from disk: read 3 pages, set 0 of
> 89423 bits
> [    3.159019] md1: detected capacity change from 0 to 24004163272704

Fairly standard, RAID5, presumably 1.2 metadata with 128M data offset, 
which is the default mdadm uses lately. Older RAIDs would have smaller 
data offsets.

So... ...the output above really is from before any of your accidents?
How old is your raid ...?

Tested with loop devices:

# truncate -s 6001175126016 0 1 2 3 4
# losetup --find --show
# mdadm --create /dev/md42 --assume-clean --data-offset=128M --level=5 --raid-devices=5 /dev/loop[01234]

| [14580.373999] md/raid:md42: device loop4 operational as raid disk 4
| [14580.373999] md/raid:md42: device loop3 operational as raid disk 3
| [14580.374000] md/raid:md42: device loop2 operational as raid disk 2
| [14580.374000] md/raid:md42: device loop1 operational as raid disk 1
| [14580.374001] md/raid:md42: device loop0 operational as raid disk 0
| [14580.374308] md/raid:md42: raid level 5 active with 5 out of 5 devices, algorithm 2
| [14580.377043] md42: detected capacity change from 0 to 24004163272704

(Results in identical capacity as yours so it's the most likely match.)

Again, you'd do this with overlays only...

Regards
Andreas Klauer
