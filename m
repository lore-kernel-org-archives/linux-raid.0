From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: RAID management questions
Date: Wed, 21 Jan 2009 20:22:51 +0100
Message-ID: <20090121192251.GB4752@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

playing around with another array, I run into a
couple of issues, so maybe someone here could
explain what could be done.

I created a RAID-1 with metadata 1.0, without
bitmap, which I added later.
The partition is around 250GB, the added bitmap
shows up as [0/8] chunk size 16384MB (or the like,
it's a huge number).

Creating the very same array, with the very same
disks, but with the bitmap, it results in something
like [0/462] chunk size 128KB (or the like, small
number, this time).

First of all, what's the difference in the two
case, in terms of efficiency, performance, etc.
Second, is it possible, if yes how, to bring
the [0/8] to [0/462] (assuming the latter is
better, of course)?
Removing and re-adding the bitmap, with chunk
size 128, returned an error ("problem with
chunk size").

Other question.
Having an array with metadata 1.0, is it possible,
if yes how, to change the array name while the
array is running?

I found it is possible during creation and assembly,
but I could not find how to do it while it is running.

Thanks a lot in advance,

bye,

-- 

piergiorgio
