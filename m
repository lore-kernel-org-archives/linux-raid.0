From: Andrey Borzenkov <arvidjaar@gmail.com>
Subject: systemd kills mdmon if it was started manually by user
Date: Sat, 4 Dec 2010 11:41:26 +0300
Message-ID: <AANLkTimHWjC5RrgZc6egrhgDLwX3zAi9ZPSvZomB2gW-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, SystemD Devel <systemd-devel@lists.freedesktop.org>
List-Id: linux-raid.ids

If user starts array manually (mdadm -A -s as example) from within
user session and array needs mdmon, mdmon becomes part of user session
control group:

=E2=94=9C user
=E2=94=82 =E2=94=94 root
=E2=94=82   =E2=94=94 1
=E2=94=82     =E2=94=9C 1916 login -- root
=E2=94=82     =E2=94=9C 1930 -bash
=E2=94=82     =E2=94=9C 1964 gpg-agent --keep-display --daemon --write-=
env-file /root/.gnup...
=E2=94=82     =E2=94=94 2062 mdmon md127


It is then killed by systemd during shutdown as part of user session.
It results in dirty array on next boot.

Is there any magic that allows daemon to be exempted from killing?

TIA

-andrey
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
