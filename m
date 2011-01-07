From: Lennart Poettering <lennart@poettering.net>
Subject: Re: systemd kills mdmon if it was started manually
 by user
Date: Fri, 7 Jan 2011 01:40:24 +0100
Message-ID: <20110107004024.GE21627@tango.0pointer.de>
References: <AANLkTimHWjC5RrgZc6egrhgDLwX3zAi9ZPSvZomB2gW-@mail.gmail.com>
	<201012041012.23757.trapni@gentoo.org>
	<AANLkTikTa8stFAcXG9jknh=RG=-Mi+xW-AD9DgZCfQ=7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <AANLkTikTa8stFAcXG9jknh=RG=-Mi+xW-AD9DgZCfQ=7@mail.gmail.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/systemd-devel>
List-Post: <mailto:systemd-devel@lists.freedesktop.org>
List-Help: <mailto:systemd-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=subscribe>
Sender: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
Errors-To: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
To: Andrey Borzenkov <arvidjaar@gmail.com>
Cc: linux-raid@vger.kernel.org, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

On Sat, 04.12.10 15:08, Andrey Borzenkov (arvidjaar@gmail.com) wrote:

> >> It is then killed by systemd during shutdown as part of user session.
> >> It results in dirty array on next boot.
> >>
> >> Is there any magic that allows daemon to be exempted from killing?
> >
> > While your raid should absolutely not be corrupted on next reboot
> > when mdmon receives a SIGTERM,
> 
> This won't be corrupted but it will initiate rebuilt. I have reports
> that such rebuild may take hours, costing performance and loss of
> redundancy.

Well, eventually we need to be able to kill mdmon. Otherwise we might
not be able to remount the root dir r/o. How exactly is mdmon supposed
to behave on shutdown?

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
