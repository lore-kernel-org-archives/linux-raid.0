From: Dmitrijs Ledkovs <xnox@debian.org>
Subject: Re: [PATCH] debian: symlink mdmon pidfile into /run/sendsigs.omit.d
Date: Fri, 24 Aug 2012 12:12:59 +0100
Message-ID: <CANBHLUgG49s1aiiKnxQTCDUF861wHv=2N+w73_7K-bi3tyysOg@mail.gmail.com>
References: <50375007.5070401@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50375007.5070401@xs4all.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24 August 2012 10:57, Miquel van Smoorenburg <mikevs@xs4all.net> wrote:
> Some daemons should not be killed when the system is shutting down. In
> debian this is achieved by putting a file with the pid of the daemon in it
> in /run/sendsigs.omit.d (or a symlink to its pidfile).
>
> This patch lets mdmon automatically create a symlink in /run/sendsigs.omit.d
> to its pidfile.
>
> See also debian bug 684708 at
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=684708  ,
> where I submitted a previous version of this patch.
>
> Comments welcome.
>

For upstream, it might be more appropriate to have a configurable
MDMON_PIDDIR, which defaults to $MDMON_DIR. As far as I know,
sendssigs.omit.d is very specific to Debian and it's derivatives, and
it's not used in the brave new systemd world.

Regards,

Dmitrijs.
