From: NeilBrown <neilb@suse.de>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Fri, 7 Jan 2011 12:16:28 +1100
Message-ID: <20110107121628.71146d21@notabene.brown>
References: <AANLkTimHWjC5RrgZc6egrhgDLwX3zAi9ZPSvZomB2gW-@mail.gmail.com>
	<20110107003827.GD21627@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110107003827.GD21627@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>
Cc: Andrey Borzenkov <arvidjaar@gmail.com>, linux-raid@vger.kernel.org, SystemD Devel <systemd-devel@lists.freedesktop.org>
List-Id: linux-raid.ids

On Fri, 7 Jan 2011 01:38:27 +0100 Lennart Poettering <lennart@poettering.net>
wrote:

> On Sat, 04.12.10 11:41, Andrey Borzenkov (arvidjaar@gmail.com) wrote:
> 
> > If user starts array manually (mdadm -A -s as example) from within
> > user session and array needs mdmon, mdmon becomes part of user session
> > control group:
> 
> Are you suggesting that mdadm forks off mdmon from within the user
> session? This is horribly ugly and broken and they shouldn't do that.

What alternative would you suggest?

A daemon needs to be running while certain md arrays are running and writable.

NeilBrown
