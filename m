From: seth vidal <skvidal@phy.duke.edu>
Subject: Re: disk failure and badblocks
Date: Sat, 22 Nov 2003 09:57:36 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1069513055.4351.8.camel@binkley>
References: <1069489341.4351.5.camel@binkley>
	 <20031122141218.GF12265@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031122141218.GF12265@percy.comedia.it>
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2003-11-22 at 09:12, Luca Berra wrote:
> On Sat, Nov 22, 2003 at 03:22:21AM -0500, seth vidal wrote:
> >My major wonder is will badblocks be effective for looking for a medium
> >error?
> only if you can disable the disk onboard cache :)
> a long time ago i changed badblocks write mode algo to write a pattern
> to the full disk THEN check it, instead of write-block, check, next
> block which was a victim of the cache. Pity i lost that patch :)

What if I made the number of blocks written at any time * the block byte
size greater than the onboard disk cache? That seems like it might
circumvent the caching problem.

-sv


