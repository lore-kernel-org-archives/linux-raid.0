From: Jon Nelson <jnelson@jamponi.net>
Subject: 20 disks, fastest possible mostly-sequential read speeds
Date: Mon, 18 May 2015 21:37:28 -0500
Message-ID: <CAKuK5J3CvbhVdyiEO8GrTje9xXq5u1eD96961vF9rA=fzAu6xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm looking for some advise on tuning.
I have a server with 20 disks behind an LSI 9271-something.
They are currently exposed as 20 individual raid0 with a "strip" size
of 1MB, and assembled into an mdraid, meta 1.2, layout 10 format f2,
with a 1MB chunk size and formatted using ext4 -T largefile.

To date, this has given me the best numbers when reading some 10,000
files (total size: about 2.5TB) sequentially or in parallel.

I can't seem to get better than about 1,800 MB/s read speeds though. I
*should* be able to get closer to 3,000 based on what the drives are
capable of. Quite some time ago on this very hardware I saw a
sustained 2,750 MB/s but I don't remember how I got there.

readahead values have been adjusted, I/O scheduler, etc... all played
with with some benefit but nothing huge. What should I be looking at
here if I want the best possible read performance?

I don't want to give up some measure of redundancy.

-- 
Jon
