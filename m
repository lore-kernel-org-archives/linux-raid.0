From: Louis-David Mitterrand <vindex@apartia.org>
Subject: switching from harware to kernel raid5
Date: Mon, 29 Apr 2002 09:22:15 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020429072215.GA26049@apartia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

On one of our servers I upgraded the 3x4.2G disks to 3x18G and removed
the Mylex Acceleraid 160 in favor of pure kernel (2.4.18) root raid5
(reiserfs) with a small raid1 (ext2) boot partition.

The reasons I did this:

- latest kernel's stability,
- raid code time tested,
- simpler hardware configuration,
- transferability of the disks to a non Mylex-equiped box,
- better performance?

Is there any downside going from hardware to kernel raid5? It seems to
work very well.=20

I even had to switch off the machine during testing because a loose PCI
card hung it: upong reboot the raid5 partition resynced itself fine. Wa=
s
I just lucky?

Thanks in advance for your insight, cheers,

--=20
    PHEDRE: Il suffit que ma main l'ait une fois touch=E9e,
            Je l'ai rendue horrible =E0 ses yeux inhumains ;
                                          (Ph=E8dre, J-B Racine, acte 3=
, sc=E8ne 1)
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
