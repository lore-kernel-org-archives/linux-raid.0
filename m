From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: read-balancing not working in 2.6?
Date: Tue, 30 Nov 2004 13:38:43 +0100
Message-ID: <20041130123841.GA19796@cistron.nl>
References: <16811.50006.976036.367501@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16811.50006.976036.367501@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, Per Andreas Buer <perbu@linpro.no>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday November 29, perbu@linpro.no wrote:
> > 
> > Hi.
> > 
> > We have a busy mailserver with the mail-spool on MD (raid1, consisting
> > of sda and sdb, ext3 w/data=journal noatime nodiratime, 2.6.6,
> > Debian Woody). The read-balancing does not seem to work properly.
> 
> The array wasn't resyncing at the time was it?
> I ask partly because resyncing substantially reduces the opportunities
> for read-balance (it will only read balance parts of the array that
> are known to  be in-sync) and partly because the amount of read
> traffic to sdb seems to start picking up at the end of your log.
> 
> If you can confirm that it wasn't resyncing, I will look into it.

You already did that in June :) It's a known bug in 2.6.6

http://marc.theaimsgroup.com/?t=108686719100002&r=1&w=2
http://marc.theaimsgroup.com/?l=linux-raid&m=108725741411235&w=2

Mike.
