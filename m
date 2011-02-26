From: Jeff Woods <jeff@jeffwoods.us>
Subject: Re: OK, Now this is really weird
Date: Sat, 26 Feb 2011 00:36:11 -0700
Message-ID: <20110226003611.tjp3cxisu880co88-xnmenx@webmail.spamcop.net>
References: <7A.41.13137.815A86D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7A.41.13137.815A86D4@cdptpa-omtalb.mail.rr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Quoting Leslie Rhorer <lrhorer@satx.rr.com>:
> 	I have a pair of drives each of whose 3 partitions are members of a
> set of 3 RAID arrays.  One of the two drives had a flaky power connection
> which I thought I had fixed, but I guess not, because the drive was taken
> offline again on Tuesday.  The significant issue, however, is that both
> times the drive failed, mdadm behaved really oddly.  The first time I
> thought it might just be some odd anomaly, but the second time it did
> precisely the same thing.  Both times, when the drive was de-registered by
> udev, the first two arrays properly responded to the failure, but the third
> array did not.  Here is the layout:

[snip lots of technical details]

> 	So what gives?  /dev/sdk3 no longer even exists, so why hasn't it
> been failed and removed on /dev /md3 like it has on /dev/md1 and /dev/md2?

Is it possible there has been no I/O request for /dev/md3 since  
/dev/sdk failed?
-- 
Jeff Woods <jeff@jeffwoods.us>
