From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: RAID1 and data safety?
Date: Tue, 29 Mar 2005 22:07:52 +0200
Message-ID: <d2cch1$tde$1@sea.gmane.org>
References: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de> <16969.10547.894461.398225@cse.unsw.edu.au> <ipqnh2-o1n.ln1@news.it.uc3m.es>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> Neil Brown <neilb@cse.unsw.edu.au> wrote:
>> Due to the system crash the data on hdb is completely ignored.  Data
> Neil - can you explain the algorithm that stamps the superblocks with
> an event count, once and for all? (until further amendment :-).

This has nothing to do with the event count but with the state bits.
And the state is set to active/dirty on start and set to clean on
stop/ro. It's just like a filesystem's state but on block device
layer.


regards
   Mario
-- 
I thought the only thing the internet was good for was porn.  -- Futurama

