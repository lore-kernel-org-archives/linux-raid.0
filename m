From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-6
Date: Wed, 13 Nov 2002 06:37:40 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15825.22660.685310.237185@notabene.cse.unsw.edu.au>
References: <aqou9k$ou5$1@cesium.transmeta.com>
	<20021112162205.GB22407@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jakob Oestergaard on Tuesday November 12
To: Jakob Oestergaard <jakob@unthought.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 12, jakob@unthought.net wrote:
> 
> You might want to consider using huge chunk-sizes when reading, but
> making sure that writes can be made on "sub-chunks" - so that one could
> run a RAID-6 with a 128k chunk size, yet have writes performed on 4k
> chunks.  This is important for performance on both read and write, but
> it is an optimization the current RAID-5 code lacks.

Either I misunderstand your point, or you misunderstand the code.

A 4k write request will cause a 4k write to a data block and a 4k
write to a parity block, no matter what the chunk size is. (There may
also be pre-reading, and possibly several 4k writes will share a
parity block update).

I see no lacking optimisation, but if you do, I would be keen to hear
a more detailed explanation.

NeilBrown
