From: Peter =?ISO-8859-1?Q?Sj=F6berg?= <peters@techwiz.ca>
Subject: Re: Hot adding active disk to RAID1?
Date: Sat, 07 Feb 2004 13:23:11 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1076178191.3328.32.camel@picard.intra.techwiz.ca>
References: <20040207152948.GA17368@fscked.org>
	 <20040207173716.GA10996@fscked.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040207173716.GA10996@fscked.org>
To: Mike Perry <mikepery@fscked.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2004-02-07 at 12:37, Mike Perry wrote:
> Thus spake Mike Perry (mikepery@fscked.org):
> 
> > Well, this is probably a FAQ, but I've really looked around..
> > Does anyone have any experience with using raidreconf for RAID1, or have
> > a way to hotadd a disk and have it become active, instead of being a
> > spare?
> 
> Ok, in my impatience I grew some balls.. As it turns out, the RAID1
> superblock is (seemingly?) independent of the contents of the volume. So
> I was able to simply mkraid --force /dev/md0, this time WITH a
> failed-disk directive. Once this was done, I was able to mount /dev/md0
> right away, no reformatting or anything needed.
> 
> Then I hot-added the failed-disk, and it seems to be synching properly.
> 
> And also this time the failed-disk wasn't mirrored to immediately either
> (ie without the explicit hotadd).. I wonder why that happened the last
> time I did this.. Maybe I just miswrote the raidtab on that occasion..
> Or possibly the partition type was raid autodetect and after the reboot
> the md driver saw this and decided to start mirroring, regardless of
> raidtab?
> 
> Anyways, sorry for the spam, but I imagine at least one other poor sap
> out there will find this useful ;)
I'm that one.
I ended up at the same place but for another reason. I was in a hurry to
build my system and knew that converting a ext3 to raid would cause some
problem because of some extra raid info, so I defined a raid1 with only
one disk. Later I bought the other disk and tried to add it by changing
/etc/raidtab but that did of course not work and it was at this point I
started to actually read the doc...
I saw reference to an old version of mkraid that would reinitialize the
superblock only (--superblock-only) and keep the data, but newer
raidtools doesn't do that. If that been there or some manpage in the
later version describing it a bit clearer I could dear to do mkraid -f
but with all incarnations of the raid software I no longer know what is
safe in my version.

My current state is that I have root mounted as /dev/md0 created with
one disk (/dev/hda5) as disk 0. I have since then added another disk and
partitioned it equal. I now want to add /dev/hdc5 to md0 (was never
mentioned before). If I add that to raidtab as failed-disk and do
"mkraid -f", will I loose anything?


> 
> P.S. I also looked at the src for raidreconf.. it in fact only supports
> raid0 and 5, and seems to be nice enough to refuse to do anything if you
> have a different raid level. So they got that going for them, which is
> nice.
-- 
-------------------------------------------------------------------
Techwiz, Peter Sjoberg    PGP key (12F506C8) on keyserver & homepage
Key fingerprint =  3DC2 CEBA 1590 B41A 3780  955A DB42 02BB 12F5 06C8
mailto:peters AT techwiz.ca http://www.techwiz.ca/~peters


