From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Multiplexed RAID-1 mode
Date: Mon, 1 Aug 2005 16:23:11 +1000
Message-ID: <17133.49103.445619.191869@cse.unsw.edu.au>
References: <Pine.LNX.4.56.0507310955400.3698@lion.drogon.net>
	<200507311907.WAA07886@raad.intranet>
	<17133.41835.683675.621675@cse.unsw.edu.au>
	<e03b90ae050731230950444b63@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeff Breidenbach on Monday August 1
Sender: linux-raid-owner@vger.kernel.org
To: jeff@jab.org
Cc: Al Boldi <a1426z@gawab.com>, Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 1, breidenbach@gmail.com wrote:
> Hi Neil, 
> 
> Are you suggesting I do this?

Well, suggesting you "try" rather than "do", but yes, that is what I
was suggesting.

> 
> mdadm --create /dev/md0 --level=10 --raid-devices=2 \
>               --parity=f2 /dev/sdc1 /dev/sdd1
> 
> I just tried it and it appears dog slow - for example
> hdparm -t /dev/md0 claims 18MB/s, and I see a similar 
> number in /proc/mdstat for resync speed.

Hmm, you're right.  It isn't as fast as I expected.  I'll look into
that.

Thanks,
NeilBrown
