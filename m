From: Bryan O'Sullivan <bos@serpentine.com>
Subject: Re: [Ext2-devel] Re: fsck out of memory
Date: 11 Feb 2003 12:04:17 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1044993857.6640.7.camel@plokta.s8.com>
References: <Pine.LNX.4.53.0302071555110.718@ddx.a2000.nu>
	 <Pine.LNX.4.53.0302071800200.1306@ddx.a2000.nu>
	 <20030207102858.P18636@schatzie.adilger.int>
	 <Pine.LNX.4.53.0302090953440.1039@ddx.a2000.nu>
	 <1044917060.11838.108.camel@sisko.scot.redhat.com>
	 <Pine.LNX.4.53.0302111410350.13269@ddx.a2000.nu>
	 <1044973982.1980.29.camel@sisko.scot.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1044973982.1980.29.camel@sisko.scot.redhat.com>
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net, tbm@a2000.nu
List-Id: linux-raid.ids

On Tue, 2003-02-11 at 06:33, Stephen C. Tweedie wrote:

> I've no idea.  Ben has some lb patches up at
> 
>   http://people.redhat.com/bcrl/lb/
> 
> but there's nothing broken out against the latest lbd diffs.

Ugh, that stuff is ancient.

Peter Chubb has a backport of his (very thorough) 2.5 patch to support
large block devices on 32-bit platforms, against much newer kernels
(e.g. 2.4.20) than Ben's stuff.  His site seems to be down, but you
should be able to get it from somewhere under
http://www.gelato.unsw.edu.au/~peterc/

I haven't used Peter's patch, but a similar patch, developed
independently, definitely allows ext3 filesystems of up to 8TB in size
to work fine on x86, under 2.4.

The nominal limit on device/filesystem size looks to be 16TB on a 32-bit
platform, but there are dozens of sign truncation errors throughout the
VFS and block layers that are unlikely to get fixed.  Hence, 8TB it is.

	<b

