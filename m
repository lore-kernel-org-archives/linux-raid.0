From: Luca Berra <bluca@comedia.it>
Subject: Re: Different output from mdadm --scan
Date: Sun, 21 Mar 2010 09:01:56 +0100
Message-ID: <20100321080156.GA12192@maude.comedia.it>
References: <7db987b31003202207w76068ed1ub3e139317d9e13aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7db987b31003202207w76068ed1ub3e139317d9e13aa@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Mar 20, 2010 at 11:07:14PM -0600, Randy Terbush wrote:
>Can someone explain why the following different outputs from the two
>mdadm --scan commands and which one is the appropriate entry in
>mdadm.conf?

It is a display bug. it was fixed in commit
6e48d593c163e8107f06d13bc6092466a5d58c94
which is rolled into mdadm 3.1.2.
I'd upgrade to that from 3.1.1 anyway, due to the massive number of
fixes that went into 3.1.2.

>mdadm --version
>mdadm - v3.1.1 - 19th November 2009
>
>#=A0mdadm --examine --scan /dev/sd*
>ARRAY /dev/md/0 metadata=3D1.1 UUID=3Db411b304:6385f171:26f07cb1:3c2b0=
3de
>name=3Dhifi:0
>
>#=A0mdadm --detail --scan
>ARRAY /dev/md0 metadata=3D1.01 name=3Dhifi:0
>UUID=3Db411b304:6385f171:26f07cb1:3c2b03de
>
>metadata attribute being the primary difference.
>
The correct entry for mdadm.conf would be "1.1", but i believe "1.01" s=
hould
be understood as well.

L.

--=20
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
