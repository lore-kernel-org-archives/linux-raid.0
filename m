From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: 5 concurrent bonnie runs failing after first pass .
Date: Thu, 21 Aug 2008 01:32:03 -0500
Message-ID: <48AD0BE3.7020403@sandeen.net>
References: <Pine.LNX.4.64.0808201853480.26204@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808201853480.26204@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: xfs@oss.sgi.com, linux-raid maillist <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Mr. James W. Laferriere wrote:
>  	Hello Dave (& Dan & All) ,
>  	Even with your patch to xfs (49641f1acfdfd437ed9b0a70b86bf36626c02afe) 
> Under some conditions multiple concurrent bonnie runs just halt .  No log to 
> dmesg or serial console .  But there is a message from something when bonnie 
> halts . 

that "something" == bonnie ...

>  Also note the really low I/O .
> 
> 
> --- Bad Bonnie --- (multiple concurrent processes)
> filesrv2,136G,,,14389,16,10165,13,,,64722,9,134.3,0,16,212,2,+++++,+++,206,2,226,1,+++++,+++,177,2
> semop: semop failed.
> : Resource temporarily unavailable
> 

Is it unique to xfs?

this is an error from bonnie's semop() call; it's not immediately clear
that there is a problem with xfs.  Is bonnie deadlocking?  Is xfs stuck?

echo w > /proc/sysrq-trigger to see if there are stuck processes and
where they are.

-Eric

