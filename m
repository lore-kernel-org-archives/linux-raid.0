From: Neil Brown <neilb@suse.de>
Subject: Re: In Trouble--Please Help!  (was Re: Can't add disk to failed raid array)
Date: Sun, 23 Jul 2006 21:59:45 +1000
Message-ID: <17603.25777.274507.385333@cse.unsw.edu.au>
References: <200607152056.55090.pwaldo@waldoware.com>
	<200607230704.46377.pwaldo@waldoware.com>
	<17603.23694.20794.434276@cse.unsw.edu.au>
	<200607230753.47853.pwaldo@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Waldo on Sunday July 23
Sender: linux-raid-owner@vger.kernel.org
To: Paul Waldo <pwaldo@waldoware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 23, pwaldo@waldoware.com wrote:
> 
> 
> At this point, I'd just be happy to be able to get the degraded array back up 
> and running.  Is there any way to do that?  Thanks!

 mdadm --assemble --force /dev/md1 /dev/hd[aceg]2 /dev/sd[ab]2

should get you the degraded array.  If not, what kernel log messages
do you get?


