From: Mike Fedyk <mfedyk@matchmail.com>
Subject: Re: 2.6.0: ext3 journal aborted with ext3/lvm/raid5
Date: Wed, 7 Jan 2004 14:42:49 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040107224249.GS1882@matchmail.com>
References: <20040107205326.GA14511@hamachi.dyndns.org> <20040107210816.GQ1882@matchmail.com> <20040107213111.GA17713@hamachi.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040107213111.GA17713@hamachi.dyndns.org>
To: Steven Ihde <sihde@cs.stanford.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 07, 2004 at 01:31:11PM -0800, Steven Ihde wrote:
> On Wed, Jan 07, 2004 at 01:08:16PM -0800, Mike Fedyk wrote:
> > Can you find the version of 2.6.0-test where this started?
> 
> This is a relatively new raid5 array -- I've been having this problem
> ever since I created the array, which was sometime after I switched to
> the 2.6.0-test series.  So I'm not claiming there is (or isn't) a
> version of 2.6.0-test that works -- only that 2.6.0-test* and 2.6.0
> are the only versions I've tried, and that's where I've seen the
> problem.

Then please verify it on a 2.4.24 kernel, or run some hardware tests.

 o Memtest86 (running all tests with at least one pass (this can take 24
   hours for one pass depending on how much memory you have...)
 o burn{BX,MMX,etc}

Mike
