From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: Re: raid1 state always "active" (ignore)
Date: Fri, 30 Jan 2009 05:36:56 -0200
Message-ID: <o9na56-v06.ln1@tux.abusar.org.br>
References: <vkma56-v06.ln1@tux.abusar.org.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 30 Jan 2009 05:25:51 -0200
D=E2niel Fraga <fragabr@gmail.com> wrote:

> 	I have this raid1 array, but the State field is always
> "active". Shouldn't it be "clean"? Is there something wrong with this
> output? Thanks.

	Sorry for my stupid question. I think now I understand what the
difference is. Clean is when there's no write to the disk and active is
when there's sync.

--=20
Linux 2.6.28: Erotic Pickled Herring
http://u-br.net


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
