From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: read-balancing not working in 2.6?
Date: Tue, 30 Nov 2004 11:48:22 +1100
Message-ID: <16811.50006.976036.367501@cse.unsw.edu.au>
References: <PERBUMSGID-ul6wtw4pevx.fsf@nfsd.linpro.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Per Andreas Buer on Monday November 29
Sender: linux-raid-owner@vger.kernel.org
To: Per Andreas Buer <perbu@linpro.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 29, perbu@linpro.no wrote:
> 
> Hi.
> 
> We have a busy mailserver with the mail-spool on MD (raid1, consisting
> of sda and sdb, ext3 w/data=journal noatime nodiratime, 2.6.6,
> Debian Woody). The read-balancing does not seem to work properly.

The array wasn't resyncing at the time was it?
I ask partly because resyncing substantially reduces the opportunities
for read-balance (it will only read balance parts of the array that
are known to  be in-sync) and partly because the amount of read
traffic to sdb seems to start picking up at the end of your log.

If you can confirm that it wasn't resyncing, I will look into it.

Thanks,
NeilBrown
