From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID1 and data safety?
Date: Tue, 29 Mar 2005 18:46:45 +0200
Message-ID: <20050329164645.GD2080@percy.comedia.it>
References: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de> <16969.10547.894461.398225@cse.unsw.edu.au> <ipqnh2-o1n.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ipqnh2-o1n.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 29, 2005 at 01:29:22PM +0200, Peter T. Breuer wrote:
>Neil Brown <neilb@cse.unsw.edu.au> wrote:
>> Due to the system crash the data on hdb is completely ignored.  Data
>
>Neil - can you explain the algorithm that stamps the superblocks with
>an event count, once and for all? (until further amendment :-).

IIRC it is updated at every event (start, stop, add, remove, fail etc...)

>It goes without saying that sb's are not stamped at every write, and the
>event count is not incremented at every write, so when and when?

the event count is not incremented at every write, but the dirty flag
is, and it is cleared lazily after some idle time.
in older code it was set at array start and cleared only at stop.

so in case of a disk failure the other disks get updated about the
failure.

in case of a restart (crash) the array will be dirty and a coin tossed
to chose which mirror to use as an authoritative source (the coin is
biased, but it doesn't matter). At this point any possible parallel
reality is squashed out of existance.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
