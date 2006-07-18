From: Neil Brown <neilb@suse.de>
Subject: Re: Can't add disk to failed raid array
Date: Tue, 18 Jul 2006 15:36:02 +1000
Message-ID: <17596.29506.188695.678634@cse.unsw.edu.au>
References: <200607152056.55090.pwaldo@waldoware.com>
	<17594.4774.17991.656057@cse.unsw.edu.au>
	<200607160824.04175.pwaldo@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Waldo on Sunday July 16
Sender: linux-raid-owner@vger.kernel.org
To: Paul Waldo <pwaldo@waldoware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 16, pwaldo@waldoware.com wrote:
> Thanks for the reply, Neil.  Here is my version:
> [root@paul log]# mdadm --version
> mdadm - v2.3.1 - 6 February 2006

Positively ancient :-)  Nothing obvious in the change log since then.

Can you show me the output of 
  mdadm -E /dev/hdd2
  mdadm -E /dev/hda2

immediately after the failed attempt to add hdd2.

Thanks,
NeilBrown
