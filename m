From: Tom Vier <tmv@comcast.net>
Subject: Re: Move md raid5 from intel to sparc?
Date: Wed, 11 Jun 2003 17:16:47 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030611211647.GB3717@zero>
References: <3EE76EDA.1060000@geodev.com>
 <200306111908.h5BJ8SsX012002@imsebackup.imse.ksu.edu>
 <20030611204421.GZ28900@mea-ext.zmailer.org>
Reply-To: Tom Vier <tmv@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20030611204421.GZ28900@mea-ext.zmailer.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 11, 2003 at 11:44:21PM +0300, Matti Aarnio wrote:
>   EXT2 has two on-disk byte orders, and kernel code understands both.
>   The MD physical format could be handled similarly.  Present code
>   (drivers/md/md.c) becomes rather upset when it sees unexpected things.

many years ago, there was ext2-be on m68k and ppc. that was an exception,
though, used before the proper cpu_to_le macros were added to the ext2 code.
ext2 is specified as le and always has been.

-- 
Tom Vier <tmv@comcast.net>
DSA Key ID 0xE6CB97DA
