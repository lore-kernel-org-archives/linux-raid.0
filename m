From: Matthew Wilcox <willy@debian.org>
Subject: Re: [Ext2-devel] Re: fsck out of memory
Date: Tue, 11 Feb 2003 20:21:57 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030211202157.Q5992@parcelfarce.linux.theplanet.co.uk>
References: <Pine.LNX.4.53.0302071555110.718@ddx.a2000.nu> <Pine.LNX.4.53.0302071800200.1306@ddx.a2000.nu> <20030207102858.P18636@schatzie.adilger.int> <Pine.LNX.4.53.0302090953440.1039@ddx.a2000.nu> <1044917060.11838.108.camel@sisko.scot.redhat.com> <Pine.LNX.4.53.0302111410350.13269@ddx.a2000.nu> <1044973982.1980.29.camel@sisko.scot.redhat.com> <1044993857.6640.7.camel@plokta.s8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1044993857.6640.7.camel@plokta.s8.com>; from bos@serpentine.com on Tue, Feb 11, 2003 at 12:04:17PM -0800
To: Bryan O'Sullivan <bos@serpentine.com>
Cc: Stephan van Hienen <raid@a2000.nu>, linux-raid@vger.kernel.org, ext2-devel@lists.sourceforge.net, tbm@a2000.nu
List-Id: linux-raid.ids

On Tue, Feb 11, 2003 at 12:04:17PM -0800, Bryan O'Sullivan wrote:
> The nominal limit on device/filesystem size looks to be 16TB on a 32-bit
> platform, but there are dozens of sign truncation errors throughout the
> VFS and block layers that are unlikely to get fixed.  Hence, 8TB it is.

and even this isn't a hard limit.  if we actually make PAGE_CACHE_SIZE
larger, then we can grow devices by the same factor.  of course, everybody
should switch to 64-bit machines.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
