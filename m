From: Michael-John Turner <mj@mjturner.net>
Subject: Re: raid1 running fine for years .. and then
Date: Mon, 12 Oct 2009 17:00:40 +0100
Message-ID: <20091012160040.GE17021@aurora.pimp.org.za>
References: <alpine.DEB.2.00.0910072350440.30153@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910072350440.30153@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 07, 2009 at 11:54:29PM -0400, Justin Piszcz wrote:
> The last time this happened, I wrote the disk with
> zeroes/badblocks/etc and failed/removed then re-added it to the array
> without any issues, now, 3-4 weeks later, it has happened again.

Rather strangely, this happened to me recently too. Exactly the same
SATA error yet nothing was in the SMART logs and the self-tests passed
perfectly. What model is the drive in question? Mine is a Samsung HD753LJ,
firmware version 1AA01109.

-mj
-- 
 Michael-John Turner
 mj@mjturner.net      <>     http://mjturner.net/
