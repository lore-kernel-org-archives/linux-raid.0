From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: RAID1 and data safety?
Date: Tue, 29 Mar 2005 13:29:22 +0200
Message-ID: <ipqnh2-o1n.ln1@news.it.uc3m.es>
References: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de> <16969.10547.894461.398225@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
> Due to the system crash the data on hdb is completely ignored.  Data

Neil - can you explain the algorithm that stamps the superblocks with
an event count, once and for all? (until further amendment :-).

It goes without saying that sb's are not stamped at every write, and the
event count is not incremented at every write, so when and when?

Thanks

Peter

