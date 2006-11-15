From: Neil Brown <neilb@suse.de>
Subject: Re: Recovering from default FC6 install
Date: Thu, 16 Nov 2006 10:49:25 +1100
Message-ID: <17755.42885.994680.290558@cse.unsw.edu.au>
References: <4556B86D.3030802@tmr.com>
	<1163345905.4138.501.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Sunday November 12
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday November 12, dledford@redhat.com wrote:
> 
> So, assuming that they are persistent, just recreate the arrays in place
> as version 1.0 superblocks with internal bitmap.  I did that exact thing
> on my FC6 machine I was testing with (raid1, not raid5, but no biggie
> there) and it worked fine.  The detailed list of instructions:
> 

You can add a bitmap to an array while it is active.
  mdadm --grow --bitmap=internal /dev/mdX

(Providing the kernel is new enough - I'm not sure when that went in,
but it was a while ago).

NeilBrown
