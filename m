From: Jurriaan <thunder7@xs4all.nl>
Subject: 3 disk raid-5 without parity
Date: Mon, 14 Jun 2004 13:19:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040614111920.GA17785@middle.of.nowhere>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am trying to convince my boss our new database-server wants raid-0+1,
not raid-5, and I got an idea while reading endless articles about
raid-5 being slow when writing and management not listening.

suppose you make a 3-disc raid-5 without parity:

data    disc1 disc2 disc3
A       A     A     B
B       B     C     C

How would that perform compared to raid-5 and raid-0+1?

As I understand, the performance problem with raid-5 when writing is
that you may need to read old data to recompute the parity block, and
the write the parity block and the data in parallel.

So in this case, you can read straight away from all 3 disks (with
raid-5 one of the disks will have parity information) and you can write
without reading old data.

There is a problem with extending this: you need groups of 3 disks.
Then again, compared to raid-0+1 you need fewer disks.

Has this ever been implemented? Even better, benchmarked?

Just in case:
[If this is a genuinly new idea, I hereby place it under the GPL.]

Jurriaan
-- 
"And in the future, if we come across any other water holes, I think
we'll drop a grenade down it first, and check the quality of the
water afterwards."
	Simon R Green - Hellworld
Debian (Unstable) GNU/Linux 2.6.7-rc2-mm2 2x6078 bogomips load 2.97
