From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6
Date: Wed, 13 Nov 2002 09:33:27 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DD28CE7.6090704@zytor.com>
References: <aqou9k$ou5$1@cesium.transmeta.com> <20021112162205.GB22407@unthought.net> <15825.22660.685310.237185@notabene.cse.unsw.edu.au> <20021113021343.GC22407@unthought.net> <15825.51226.122496.604304@notabene.cse.unsw.edu.au> <20021113122957.GE22407@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Jakob Oestergaard <jakob@unthought.net>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jakob Oestergaard wrote:
>>
>>When doing sequential writes, a small chunk size means you are more
>>likely to fill up a whole stripe before data is flushed to disk, so it
>>is very possible that you wont need to pre-read parity at all.  With a
>>larger chunksize, it is more likely that you will have to write, and
>>possibly read, the parity block several times.
> 
> Except if one worked on 4k sub-chunks - right  ?   :)
> 

No.  You probably want to look at the difference between RAID-3 and 
RAID-4 (RAID-5 being basically RAID-4 twisted around in a rotating pattern.)

> 
> So, by making a big chunk-sized array, and having it work on 4k
> sub-chunks for writes, was some idea I had which I felt would just give
> the best scenario in both cases.
> 
> Am I smoking crack, or ?  ;)
> 

No, you're confusing RAID-3 and RAID-4/5.  In RAID-3, sequential blocks 
are organized as:

	DISKS ------------------------------------>
	 0	 1	 2	 3	PARITY
	 4	 5	 6	 7	PARITY
	 8	 9	10	11	PARITY
	12	13	14	15	PARITY

... whereas in RAID-4 with a chunk size of four blocks it's:

	DISKS ------------------------------------>
	 0	 4	 8	12	PARITY
	 1	 5	 9	13	PARITY
	 2	 6	10	14	PARITY
	 3	 7	11	15	PARITY

If you only write blocks 0-3 you *have* to read in the 12 data blocks 
and write out all 4 parity blocks, whereas in RAID-3 you can get away 
with only writing 5 blocks.  [Well, technically you could also do a 
read-modify-write on the parity, since parity is linear.  This would 
greatly complicate the code.]

Therefore, for small sequential writes chunking is *inherently* a lose, 
and there isn't much you can do about it.

	-hpa


