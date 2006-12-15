From: Andrew Morton <akpm@osdl.org>
Subject: Re: md patches in -mm
Date: Fri, 15 Dec 2006 12:06:03 -0800
Message-ID: <20061215120603.41ff6fed.akpm@osdl.org>
References: <20061204203410.6152efec.akpm@osdl.org>
	<17780.63770.228659.234534@cse.unsw.edu.au>
	<20061205061623.GA13749@amd64.of.nowhere>
	<20061205062142.GA14784@amd64.of.nowhere>
	<20061204224323.2e5d0494.akpm@osdl.org>
	<20061205105928.GA6482@amd64.of.nowhere>
	<17782.28505.303064.964551@cse.unsw.edu.au>
	<20061215192146.GA3616@amd64.of.nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061215192146.GA3616@amd64.of.nowhere>
Sender: linux-raid-owner@vger.kernel.org
To: Jurriaan <thunder7@xs4all.nl>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 15 Dec 2006 20:21:46 +0100
thunder7@xs4all.nl wrote:

> From: Neil Brown <neilb@suse.de>
> Date: Wed, Dec 06, 2006 at 06:20:57PM +1100
> > i.e. current -mm is good for 2.6.20 (though I have a few other little
> > things I'll be sending in soon, they aren't related to the raid6
> > problem).
> > 
> 2.6.20-rc1-mm1 doesn't boot on my box, due to the fact that e2fsck gives
> 
> Buffer I/O error on device /dev/md0, logical block 0
> 
> and after that 1,2,3,4,5,6,7,8,9, at which points it complains it can't
> read the superblock. It seems the raid6 problem hasn't gone away
> completely, after all.

Odd.  The only md patch in rc1-mm1 is the truly ancient 
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

Does 2.6.20-rc1 work?
