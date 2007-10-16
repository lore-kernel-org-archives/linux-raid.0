From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: Partitionable raid array... How to create devices ?
Date: Tue, 16 Oct 2007 11:35:37 +0200
Message-ID: <20071016113537.69021215@absurd>
References: <471474D6.5090704@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471474D6.5090704@systella.fr>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

BERTRAND Jo=EBl said:     (by the date of Tue, 16 Oct 2007 10:22:46 +02=
00)


>=20
> Root gershwin:[/dev] > ls -l md*
> brw-rw---- 1 root disk  9,   0 Oct 15 10:29 md0
> brw-rw---- 1 root disk  9,   1 Oct 15 10:29 md1
> brw-rw---- 1 root disk  9, 127 Oct 16 09:59 md127
> brw-rw---- 1 root disk  9,   2 Oct 15 10:29 md2
> brw-rw---- 1 root disk  9,   3 Oct 15 10:29 md3
> brw-rw---- 1 root disk  9,   4 Oct 15 10:29 md4
> brw-rw---- 1 root disk  9,   5 Oct 15 10:29 md5
> brw-rw---- 1 root disk  9,   6 Oct 15 10:29 md6
> brw-rw---- 1 root disk  9,   7 Oct 15 10:29 md7
> brw-rw---- 1 root disk  9,   8 Oct 15 10:29 md8
> crw-rw---- 1 root root 10,  63 Oct 15 10:29 mdesc
> brw-rw---- 1 root disk  9, 127 Oct 16 10:03 mdp0



=2E.. crazy. Much better to create just /dev/md0 and use LVM

http://tldp.org/HOWTO/Software-RAID-HOWTO-11.html

--=20
Janek Kozicki                                                         |
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
