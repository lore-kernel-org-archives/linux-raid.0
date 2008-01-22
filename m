From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: One Large md or Many Smaller md for Better Peformance?
Date: Tue, 22 Jan 2008 00:32:13 -0200
Message-ID: <18325.21933.337369.104689@fisica.ufpr.br>
References: <4793AE0E.609@pobox.com>
	<20080120215734.GD17584@teal.hq.k1024.org>
	<47940F31.7020907@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47940F31.7020907@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky (moshe@pobox.com) wrote on 20 January 2008 21:19:
 >Thanks for the tips, and in particular:
 >
 >Iustin Pop wrote:
 >
 >>   - if you download torrents, fragmentation is a real problem, so use a
 >>     filesystem that knows how to preallocate space (XFS and maybe ext4;
 >>     for XFS use xfs_io to set a bigger extend size for where you
 >>     download)
 >
 >That's a very interesting idea; it also gives me an opportunity to 
 >experiment with XFS. I had been avoiding it because of possible 
 >power-failure issues on writes.

I use reiser3 and xfs. reiser3 is very good with many small files. A
simple test shows interactively perceptible results: removing large
files is faster with xfs, removing large directories (ex. the kernel
tree) is faster with reiser3.
