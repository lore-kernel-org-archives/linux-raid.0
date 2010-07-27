From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Increase request size for levels other than raid0?
Date: Tue, 27 Jul 2010 15:22:27 +0200
Message-ID: <slrni4tncj.lr8.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <slrni4r002.lr8.Mario.Holbe@darkside.dyn.samba-tng.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE> wrote:
> I have a raid0 over 4x dm-crypt over 4x raid1 (degraded) over 4 disks
...
> Since request size is a limiting factor for dm-crypt performance, it
> would be great if at least raid1 could also tune itself to the
> underlying queue max_hw_sectors (or at least max_sectors).

Just as a small motivation: eliminating raid1 in the above setup gains
me +50MB/s raw dd-throughput (260MB/s vs. 310MB/s). When a filesystem
(xfs) enters the game, the gain can increase even more - I remember
about 300MB/s streaming read on a pure device-mapper based setup
comparable to mine (same hardware) while I'm now stuck at about 210MB/s.


regards
   Mario
-- 
The opposite of a correct statement is a false statement.
But the opposite of a profound truth may well be another profound truth.
                                                           -- Niels Bohr

