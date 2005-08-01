From: Jeff Breidenbach <breidenbach@gmail.com>
Subject: Re: Multiplexed RAID-1 mode
Date: Mon, 1 Aug 2005 02:09:20 -0400
Message-ID: <e03b90ae050731230950444b63@mail.gmail.com>
References: <Pine.LNX.4.56.0507310955400.3698@lion.drogon.net>
	 <200507311907.WAA07886@raad.intranet>
	 <17133.41835.683675.621675@cse.unsw.edu.au>
Reply-To: jeff@jab.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17133.41835.683675.621675@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Al Boldi <a1426z@gawab.com>, Gordon Henderson <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil, 

Are you suggesting I do this?

mdadm --create /dev/md0 --level=10 --raid-devices=2 \
              --parity=f2 /dev/sdc1 /dev/sdd1

I just tried it and it appears dog slow - for example
hdparm -t /dev/md0 claims 18MB/s, and I see a similar 
number in /proc/mdstat for resync speed.

Getting rid of the --parity=f2 parameter, the numbers 
jump up to about 65MB/s which is similar to single drive
transfer rate.

Anyway, I haven't thoroughly benchmarked and I know hdparm
is not to be trusted, but so far it's not obvious to me level=10 
beats level=1 for a two drive array. If you think it is worth 
pursuing I will do so.

Cheers,
Jeff

PS. I care most about small (~5K) file read performance. Think
very busy webserver with hundreds of gigabytes of small files.
And an occasional medium size file of a few megabytes.
