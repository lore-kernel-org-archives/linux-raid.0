From: Andy Smith <andy@strugglers.net>
Subject: Re: Re-assembling array after double device failure
Date: Fri, 31 Mar 2017 04:25:10 +0000
Message-ID: <20170331042510.GD4349@bitfolk.com>
References: <20170327133813.GQ4349@bitfolk.com>
 <eb7bebad-f173-b6e9-75f8-182148eccc46@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <eb7bebad-f173-b6e9-75f8-182148eccc46@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Anthony,

On Mon, Mar 27, 2017 at 04:23:19PM +0100, Anthony Youngman wrote:
> Hopefully fixing the timeout, followed by a --assemble --force, then
> a scrub, will be all that's required.

Yep, thanks. Luckily it assembled without --force, and I was then
able to replace the older drive with a new one and rebuild onto it.
It completed that without error and seems happy now.

I'm going to subject the removed drive that got kicked out first to
some more in-depth scrutiny in another machine as soon as I get
chance.

Cheers,
Andy
