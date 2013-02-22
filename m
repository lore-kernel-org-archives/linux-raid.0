From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: Re: BUG  - raid 1 deadlock on handle_read_error / wait_barrier
Date: Fri, 22 Feb 2013 13:14:32 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1302221312450.1736@jlaw-desktop.mno.stratus.com>
References: <1361487504.4863.54.camel@linux-lxtg.site>  <51275BF6.2050702@gmail.com> <1361549003.4863.58.camel@linux-lxtg.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1361549003.4863.58.camel@linux-lxtg.site>
Sender: linux-raid-owner@vger.kernel.org
To: Tregaron Bayly <tbayly@bluehost.com>
Cc: majianpeng <kedacomkernel@gmail.com>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Fri, 22 Feb 2013, Tregaron Bayly wrote:
> Also, I don't know for sure but it didn't sound like Joe Lawrence is
> using the same lower layer drivers but he has the same problem.

I'm running a slightly modified mpt2sas driver under 3.8.0rcX (not 3.7 as 
I mentioned earlier).

I did capture a kdump vmcore on the freeze_array hang, but haven't had 
time to look at it yet.

Regards,

-- Joe
