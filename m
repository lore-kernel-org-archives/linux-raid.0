From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: mdadm 3.0.3 bug report
Date: Mon, 9 Nov 2009 18:30:07 -0600
Message-ID: <cccedfc60911091630i5a59b2x8e8f9cfd1c6b69cd@mail.gmail.com>
References: <cccedfc60911090743m77b26b7bx98bf5d18b7e96311@mail.gmail.com>
	<4877c76c0911091624u6afc98dt5367b55c35eb997c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911091624u6afc98dt5367b55c35eb997c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Nov 9, 2009 at 6:24 PM, Michael Evans <mjevans1983@gmail.com> w=
rote:
> $ perror 1
> OS error code =A0 1: =A0Operation not permitted
>
> Will it let you create that with another layout type? (such as near o=
r
> offset) or with another metadata container format (such as 1.1)?

Yes, I understand error codes.
However, I was still expecting an error *message*.

With metadata=3D1.1, I get:

mdadm: array /dev/md/3 started.
(and exit code 0, of course)


--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
