From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Force raid5 assemble at boot kernel
Date: Tue, 19 Oct 2004 11:33:14 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16756.28378.936295.221580@cse.unsw.edu.au>
References: <20041018083744.48600.qmail@web51708.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mario Mendeni on Monday October 18
To: Mario Mendeni <htrafmb@yahoo.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 18, htrafmb@yahoo.it wrote:
> Hi all,
>   i've got a / over a failed raid5. i mean, three
> disks: one broken (a), one good (b), one failed (c).
> the last one was kicked out of the array because a
> read error. anyway, no trouble because i've got backup
> and so on. Well, if I boot from another disk and force
> assembly it restarts, but I would like to know if I
> can force the assembly of md0 for device (b) and (c)
> from kernel command line (grub/lilo).

No, you cannot.  In this situation the kernel simply will not trust
the data.  You need mdadm to modify the superblocks before it will
assemble it.=20

NeilBrown



>=20
> Thanks a lot for your time and your work,
> andrea (a happy software raid user)
>=20
>=20
> 	=09
> ___________________________________=20
> Nuovo Yahoo! Messenger: E' molto pi=1B,Ay=1B(B divertente: Audibles, =
Avatar, Webcam, Giochi, Rubrica=85 Scaricalo ora!=20
> http://it.messenger.yahoo.it
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
