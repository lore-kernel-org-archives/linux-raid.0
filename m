From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: AWFUL reshape speed with raid5.
Date: Mon, 28 Jul 2008 13:24:00 -0500
Message-ID: <cccedfc60807281124w6301915bo88b8be45599f4fb3@mail.gmail.com>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>
	 <alpine.DEB.1.10.0807281414020.3288@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0807281414020.3288@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jul 28, 2008 at 1:14 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> What happens if you use 0.90 superblocks?

An even more spectacular explosion. Really quite impressive, actually.
Just a small sample of the >800 lines:

Jul 28 13:18:54 turnip kernel: itmap 9: invalid bitmap page 9: invalid
bitmap page 9: invalid bitmap p9: invalid bitmap pag9: invalid bitmap
9: invalid bitmap page9: invalid bitmap pa9: invalid bitmap pag9:
invalid bitmap 9: invalid bitmap 9: invalid bitmap pag9: invalid
bitmap page9: invalid bitmap 9: invalid bitmap 9: invalid bitmap
page9: invalid bitmap pa9: invalid bitmap pag9: invalid bitmap pa9:
invalid bitmap p9: invalid bitmap page 9: invalid bitmap page 9:
invalid bitmap p9: invalid bitmap 9: invalid bitmap page9: invalid
bitmap pag9: invalid bitmap pag9: invalid bitmap page9: invalid bitmap
9: invalid bitmap pag9: invalid bitmap page9: invalid bitmap pag9:
invalid bitmap9: invalid bitmap page9: invalid bitmap pag9: invalid
bitmap pa9: invalid bitmap page9: invalid bitmap pa9: invalid bitmap
p9: invalid bitmap page 9: invalid bitmap page 9: invalid bit9:
invalid bitmap pa9: invalid bitmap page 9: invalid bitmap pag9:
invalid bitmap page9: invalid bitmap 9: invalid bitmap pa9: invalid
bitmap page9: invalid

(Note the page -> pag -> p ... variations/corruption/whatever).

and

Jul 28 13:18:55 turnip kernel: i9: i9: 9: 9: i9: 9: i9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: i9: 9: 9: 9: 9: 9: 9: 9: 9: i9: i9: 9: i9: 9: i9:
i9: 9: 9: i9: 9: i9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: i9: 9: 9: 9: 9:
9: 9: 9: 9: i9: i9: 9: in9: 9: 9: 9: 9: 9: i9: 9: i9: 9: i9: 9: i9:
i9: 9: 9: 9: 9: 9: 9: i9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: i9: 9: i9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: i9: i9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: i9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: i9: i9: 9: 9: 9: 9: 9: 9: i9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
Jul 28 13:18:55 turnip kernel:  9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: i9: i9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: i9: i9: 9: 9:
9: 9: 9: 9: 9: i9: 9: i9: 9: i9: 9: i9: 9: i9: 9: i9: 9: i9: 9: i9: 9:
i9: 9: i9: 9: i9: 9: i9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: i9: 9: i9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9:
9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: 9: invalid bitmap page request:
222 (> 122)



> Also, are these sata ports on the mobo or sata ports on a pci-based mobo?

The ports are on a PCI-E motherboard, MCP55 chipset. The
motherboard/chipset/whatever is *not* the problem.

-- 
Jon
