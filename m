From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Feature Request/Suggestion - "Drive Linking"
Date: Sun, 03 Sep 2006 22:35:25 +0400
Message-ID: <44FB206D.6000206@tls.msk.ru>
References: <1156868468.5611.102.camel@localhost> <5b170a7d0609030759u2b145237m85757ec649f86488@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b170a7d0609030759u2b145237m85757ec649f86488@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tuomas Leikola <tuomas.leikola@gmail.com>
Cc: Neil Bortnak <linux-raid@moro.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tuomas Leikola wrote:
[]
> Here's an alternate description. On first 'unrecoverable' error, the
> disk is marked as FAILING, which means that a spare is immediately
> taken into use to replace the failing one. The disk is not kicked, and
> readable blocks can still be used to rebuild other blocks (from other
> FAILING disks).
> 
> The rebuild can be more like a ddrescue type operation, which is
> probably a lot faster in the case of raid6, and the disk can be
> automatically kicked after the sync is done. If there is no read
> access to the FAILING disk, the rebuild will be faster just because
> seeks are avoided in a busy system.

It's not that simple.  The issue is with writes.  If there's a "failing"
disk, md code will need to keep track of "up-to-date", or "good" sectors
of it vs "obsolete" ones.  Ie, when write fails, the data in that block
is either unreadable (but can become readable on the next try, say, after
themperature change or whatnot), or readable but contains old data, or
is readable but contains some random garbage.  So at least that block(s)
of the disk should not be copied to the spare during resync, and should
not be read at all, to avoid returning wrong data to userspace.  In short,
if the array isn't stopped (or changed to read-only), we should watch for
writes, and remember which ones are failed.  Which is some non-trivial
change.  Yes, bitmaps somewhat helps here.

/mjt

-- 
VGER BF report: H 0.418675
