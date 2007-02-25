From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: nonzero mismatch_cnt with no earlier error
Date: Sun, 25 Feb 2007 19:33:32 +0100
Message-ID: <20070225183332.GA10098@janus>
References: <45DF859B.2050108@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45DF859B.2050108@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Feb 24, 2007 at 11:23:55AM +1100, Eyal Lebedinsky wrote:
[...]
> 
> fsck (ext3 with logging) found no errors but I may have bad data
> somewhere.

I've written a program for fast MD5/SHA256 summing which may be useful
for tracking these kind of silent corruptions. See

	http://www.frankvm.com/fsindex

-- 
Frank
