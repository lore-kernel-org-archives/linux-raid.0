From: Martin Ziler <martin.ziler@googlemail.com>
Subject: Re: degraded raid 6 (1 bad drive) showing up inactive, only spares
Date: Sun, 17 Jun 2012 17:52:07 +0200
Message-ID: <F137B54C-A982-4EBC-A04B-5C47CA07BE12@googlemail.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello everybody,

long time no seen. As I was unable to find a permutation that would result in an fsck-output that looks ok I generated the 360.000 permutations using Neil's shell script. I then composed a little script that would try a permutation, do the fsck, stop the raid an go on with the new possibility and inserted the fsck-output into a text-file. The whole 360.000 permutations just recently finished - after some 6 days of building and fscking. I have not yet analyzed the output. I did however search for the term "clean" as a positive result would possibly contain that term.

I got 711 different drive-combinations that will result in this: /dev/md0: clean, 204968/849158144 files, 3394436623/3396621312 blocks.

If there really is only one working drive order, I guess I am pretty much doomed. I do hope I'll be able to rule out a large portion of those results before going into some more detail. I did get it correct, though, that there is only one possible order resulting in a working array? I gotta figure out how to analyze the output file now. It's 125 MB. I guess I'll probably split it and load it into my spreadsheet. In one go I'd stumble across the 1.000.000 row-limit.

regards,

Martin