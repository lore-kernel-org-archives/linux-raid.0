From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: RAID1 and data safety?
Date: Tue, 29 Mar 2005 11:27:02 +0200
Message-ID: <6kjnh2-qn4.ln1@news.it.uc3m.es>
References: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Schuett Thomas EXT <Thomas.Schuett.extern@mchh.siemens.de> wrote:
> And here the fault happens:
> By chance, it reads the transaction log from hda, then sees, that the
> transaction was finished, and clears the overall unclean bit. 
> This cleaning is a write, so it goes to *both* HDs.

Don't put the journal on the raid device, then - I'm not ever sure why
people do that!  (they probably have a reason that is good - to them).

Or put it on another raid partition/device on the same media, but one
set to error unless replication is perfect (there does seem to be a use
for that policy!).

Peter

