From: Mike Fedyk <mfedyk@matchmail.com>
Subject: Re: 2.6.0: ext3 journal aborted with ext3/lvm/raid5
Date: Wed, 7 Jan 2004 13:08:16 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040107210816.GQ1882@matchmail.com>
References: <20040107205326.GA14511@hamachi.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040107205326.GA14511@hamachi.dyndns.org>
To: Steven Ihde <sihde@cs.stanford.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 07, 2004 at 12:53:26PM -0800, Steven Ihde wrote:
> 
> I get "Aborting journal on device dm-x" and associated errors about
> every week or two.  This is on a 2.6.0 kernel, ext3 filesystem running
> on lvm over md raid5.  This has been happening since at least some
> point in the 2.6.0-test series.

Have you run fsck on this filesystem?

Can you find the version of 2.6.0-test where this started?
