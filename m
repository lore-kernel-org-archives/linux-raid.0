From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: sata badness in 2.6.20-rc1? [Was: Re: md patches in -mm]
Date: Fri, 15 Dec 2006 22:06:18 +0000
Message-ID: <20061215220618.06f1873c@localhost.localdomain>
References: <20061204203410.6152efec.akpm@osdl.org>
	<17780.63770.228659.234534@cse.unsw.edu.au>
	<20061205061623.GA13749@amd64.of.nowhere>
	<20061205062142.GA14784@amd64.of.nowhere>
	<20061204224323.2e5d0494.akpm@osdl.org>
	<20061205105928.GA6482@amd64.of.nowhere>
	<17782.28505.303064.964551@cse.unsw.edu.au>
	<20061215192146.GA3616@amd64.of.nowhere>
	<17795.2681.523120.656367@cse.unsw.edu.au>
	<20061215130552.95860b72.akpm@osdl.org>
	<20061215133927.a8346372.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753476AbWLOV6Q@vger.kernel.org>
In-Reply-To: <20061215133927.a8346372.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Neil Brown <neilb@suse.de>, Jurriaan <thunder7@xs4all.nl>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
List-Id: linux-raid.ids

On Fri, 15 Dec 2006 13:39:27 -0800
Andrew Morton <akpm@osdl.org> wrote:

> On Fri, 15 Dec 2006 13:05:52 -0800
> Andrew Morton <akpm@osdl.org> wrote:
> 
> > Jeff, I shall send all the sata patches which I have at you one single time
> > and I shall then drop the lot.  So please don't flub them.
> > 
> > I'll then do a rc1-mm2 without them.
> 
> hm, this is looking like a lot of work for not much gain.  Rafael, are
> you able to do a quick chop and tell us whether these:

The md one and the long history of reports about parallel I/O causing
problems sounds a lot more like the kmap stuff you were worried about
Andrew. I'd be very intereste dto know if it happens on x86_32 built with
a standard memory split and no highmem....
