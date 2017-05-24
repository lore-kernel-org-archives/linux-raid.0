From: Nix <nix@esperi.org.uk>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Wed, 24 May 2017 20:42:48 +0100
Message-ID: <87d1ayhwhz.fsf@esperi.org.uk>
References: <87lgppz221.fsf@esperi.org.uk>
        <87a865jf9a.fsf@notabene.neil.brown.name>
        <87fufwy3lr.fsf@esperi.org.uk>
        <87poezhwsa.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87poezhwsa.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Wed, 24 May 2017 11:24:21 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24 May 2017, NeilBrown said:
> Alternately, this might do it.

Bingo! Ticking away nicely:

[  147.538274] md/raid:md125: device sda3 operational as raid disk 0
[  147.574356] md/raid:md125: device sdd3 operational as raid disk 3
[  147.586482] md/raid:md125: device sdc3 operational as raid disk 2
[  147.598571] md/raid:md125: device sdb3 operational as raid disk 1
[  147.613949] md/raid:md125: raid level 6 active with 4 out of 5 devices, algorithm 18
[  147.776155] md: reshape of RAID array md125

md125 : active raid6 sda3[0] sdf3[5] sdd3[4] sdc3[2] sdb3[1]
      15391689216 blocks super 1.2 level 6, 512k chunk, algorithm 18 [5/4] [UUUU_]
      [>....................]  reshape =  0.0% (2669056/5130563072) finish=1363.5min speed=62678K/sec

(wow, this is a lot faster: only 1363 min / 70MiB/s, versus the
--backup-file one, for an array half the size, that was >2500 min,
12MiB/s. I mean, yes, it was at the slow end of the disk, but they don't
differ in speed *that* much.)

Machine still perfectly responsive, as if on reshape was happening at
all. (But then, I've got used to that. The last time I saw any md resync-
induced delays was long ago when I had a sym53c75 in the loop with an
I/O rate of 10MiB/s. I think delays are unavoidable with something
that slow in there.)
