From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Hot adding active disk to RAID1?
Date: Tue, 10 Feb 2004 19:22:19 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16424.38075.333116.361351@notabene.cse.unsw.edu.au>
References: <20040207152948.GA17368@fscked.org>
	<20040207173716.GA10996@fscked.org>
	<1076178191.3328.32.camel@picard.intra.techwiz.ca>
	<20040210075406.GB15112@fscked.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Perry on Tuesday February 10
To: Mike Perry <mikepery@fscked.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday February 10, mikepery@fscked.org wrote:
> 
> I concur. The manpages really should clear up that raidhotadd (and mdadm
> -a) only add spares. And they should further clarify that spares are
> essentially useless and lie dormant.. The names of these
> commands/options are very deceptive to the new user...

Patches are more that welcome.
It is very hard for someone how knows the system "inside-out" to see
which areas aren't explained well.

NeilBrown

