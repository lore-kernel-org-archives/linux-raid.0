From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-6
Date: Thu, 14 Nov 2002 09:50:53 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15826.55117.413932.676392@notabene.cse.unsw.edu.au>
References: <aqou9k$ou5$1@cesium.transmeta.com>
	<20021112162205.GB22407@unthought.net>
	<15825.22660.685310.237185@notabene.cse.unsw.edu.au>
	<20021113021343.GC22407@unthought.net>
	<15825.51226.122496.604304@notabene.cse.unsw.edu.au>
	<20021113122957.GE22407@unthought.net>
	<3DD28CE7.6090704@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from H. Peter Anvin on Wednesday November 13
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jakob Oestergaard <jakob@unthought.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 13, hpa@zytor.com wrote:
> 
> 	DISKS ------------------------------------>
> 	 0	 4	 8	12	PARITY
> 	 1	 5	 9	13	PARITY
> 	 2	 6	10	14	PARITY
> 	 3	 7	11	15	PARITY
> 
> If you only write blocks 0-3 you *have* to read in the 12 data blocks 
> and write out all 4 parity blocks, whereas in RAID-3 you can get away 
> with only writing 5 blocks.  [Well, technically you could also do a 
> read-modify-write on the parity, since parity is linear.  This would 
> greatly complicate the code.]

We do read-modify-write if it involves fewer pre-reads than
reconstruct-write.
so in the above scenario, writing blocks 0,1,2,3 would cause a
pre-read of those blocks and the 4 parity blocks, and then all 8
blocks would be re-written.

NeilBrown
