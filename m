From: Michael Biebl <mbiebl@gmail.com>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually by user
Date: Fri, 7 Jan 2011 02:09:32 +0100
Message-ID: <AANLkTi=4U9E4GtYkmj+XvXLDHKTbP9AHkZ_=DhC7xNBd@mail.gmail.com>
References: <AANLkTimHWjC5RrgZc6egrhgDLwX3zAi9ZPSvZomB2gW-@mail.gmail.com>
	<20110107003827.GD21627@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110107003827.GD21627@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>
Cc: Andrey Borzenkov <arvidjaar@gmail.com>, linux-raid@vger.kernel.org, SystemD Devel <systemd-devel@lists.freedesktop.org>
List-Id: linux-raid.ids

2011/1/7 Lennart Poettering <lennart@poettering.net>:
>
> Well, I have been discussing this with Kay and we'll most likely add
> something like DontKillOnShutdown=yes or so, which if added to a unit

Make that KillOnShutdown=no, please.


-- 
Why is it that all of the instruments seeking intelligent life in the
universe are pointed away from Earth?
