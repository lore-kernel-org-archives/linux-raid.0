From: Samuli Suominen <ssuominen@gentoo.org>
Subject: Re: [PATCH] Parallel make bug in Makefile of mdadm-3.3.1 (corrupted
 udev rules and/or systemd services)
Date: Thu, 17 Jul 2014 10:45:05 +0300
Message-ID: <53C77F01.9030208@gentoo.org>
References: <53C77B7D.2090907@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53C77B7D.2090907@gentoo.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 17/07/14 10:30, Samuli Suominen wrote:
> If you run with:
>
> $ export MAKEFLAGS="-j9"
> $ make install install-systemd
>
> As in, combine "install" and "install-systemd" in the same command using
> parallel make,
> the content of .service files could end up in .rules, or otherway around
> because GNU
> make fill

s/fill/will/

>
> And the attach

s/attach/attached/

Sorry for the embarrasing typing errors in the first post.
