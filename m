From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: reconstrucion after a failed drive restarts on reboot
Date: Fri, 4 Apr 2003 10:18:47 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16012.53095.773418.264464@notabene.cse.unsw.edu.au>
References: <200304031611.IAA13915@washington.seas.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephen C Woods on Thursday April 3
To: Stephen C Woods <scw@seas.ucla.edu>
Cc: Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday April 3, scw@seas.ucla.edu wrote:
>    After a drive has failed reconstruction restarts (this is the
> expected result),  however if for some reason sthe system is rebooted
> (even if mdadm --stop /dev/md0 has been done) reconstrcution restarts
> from the begining.  Is there some way to have md save the last completed
> point and pick up from there?
> 

This functionality is (largely) in 2.5 but is unlikely to be
back-ported to 2.4.

NeilBrown
