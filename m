From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Two RAID6 questions
Date: Fri, 20 Jan 2006 18:02:07 +0400
Message-ID: <43D0ED5F.5080208@wasp.net.au>
References: <1137762704.20659.51.camel@kenny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1137762704.20659.51.camel@kenny>
Sender: linux-raid-owner@vger.kernel.org
To: John Rowe <rowe@excc.ex.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Rowe wrote:
> 
> First, can raidreconf grow a RAID6 device? The man page doesn't seem to
> mention RAID6 at all.

No, raidreconf has no knowledge of raid-6 at all.

> Second, with RAID5 or RAID6 my biggest fear is a system crash whilst the
> RAID is writing resulting in dirty blocks. Does RAID6 give some sort of
> ECC capability when reconstructing? I'm imagining checking the parity of
> a RAID block and if it's wrong assuming each block in turn is dirty,
> recalculating it from the first parity and then checking the result
> against the second parity.

This is just one of those things.. if you crash while writing, unless you have hardware raid with 
NVRAM you are going to leave the array in an unclean, uncertain state..
The best you can do is re-sync the array, fsck the filesystem and hope for the best..

The greatest new feature in md in this regard is the periodically mark the array as clean while it's 
idle.. It generally ensures that most of the time on a crash you don't need a resync on the next 
assemble.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
