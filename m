From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: RAID 0, disks swapped ?
Date: Fri, 17 Oct 2008 16:05:53 +0200
Message-ID: <gda641$spp$2@ger.gmane.org>
References: <200810171318.12654.c.baegert-listes@lixium.fr>
 <48F89094.2080504@tmr.com> <200810171548.59686.c.baegert-listes@lixium.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

c.baegert-listes@lixium.fr <c.baegert-listes@lixium.fr> wrote:
> older. The good point of the RAID 1+0 solution is that I just have to=
 repair=20
> a raid0 array now. But how ?

That's most likely gone - at least your data is most likely corrupted
after your reiserfsck and rebuild-tree, unless all you did did not writ=
e
to the disks (which is not very likely :)).
You could try to recreate the array in the correct order, perhaps you
can get a little back but i think its time to consult your backups,
alone to find out what's corrupted and what's not.


regards
   Mario
--=20
Damit das M=F6gliche entsteht, mu=DF immer wieder das Unm=F6gliche vers=
ucht werden.
                                                  -- Hermann Hesse

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
