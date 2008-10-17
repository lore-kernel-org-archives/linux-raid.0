From: c.baegert-listes@lixium.fr
Subject: Re: RAID 0, disks swapped ?
Date: Fri, 17 Oct 2008 15:57:30 +0200
Message-ID: <200810171557.30177.c.baegert-listes@lixium.fr>
References: <200810171318.12654.c.baegert-listes@lixium.fr> <gda0t0$9o2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <gda0t0$9o2$1@ger.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@tu-ilmenau.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le vendredi 17 octobre 2008, vous avez =E9crit :
> This is true for assembling an existing RAID (provided it has a
> superblock), but when you create a new one ... where should md know t=
he
> order except from what you gave it?
> But... why did you have to recreate it at all?

If I remember well, a re-add failed after a disk lost sync, so I had to=
=20
re-create the RAID 1 array after stopping it, and then I had to stop th=
e RAID=20
0 before...

Regards,
--=20
=20
Christophe
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
