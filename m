From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Fri, 16 Mar 2012 13:01:42 -0500
Message-ID: <CAKuK5J3GHgWcnYLqwRV8s_wMjO2nBVf7h=yONtn90kPn9A_3Gg@mail.gmail.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
 <4F61803A.60009@hardwarefreak.com> <CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
 <4F633121.10800@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F633121.10800@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 16, 2012 at 7:25 AM, Stan Hoeppner <stan@hardwarefreak.com>=
 wrote:
=2E.
> You just stated the the Linux defaults. =C2=A0Do note that XFS write =
barriers
> will ensure journal and thus filesystem integrity in a crash/power fa=
il
> event. =C2=A0They do NOT guarantee file data integrity as file data i=
sn't
> journaled. =C2=A0No filesystem (Linux anyway) journals data, only met=
adata.

=2E.

That's not true, is it? ext3 and ext4 support journal=3Ddata.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
