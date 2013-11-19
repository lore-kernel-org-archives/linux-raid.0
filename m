From: Guillaume Betous <guillaume.betous@gmail.com>
Subject: Is my drive dying ?
Date: Tue, 19 Nov 2013 07:58:10 +0100
Message-ID: <CAPbD+RcuxFY0gwMNm5Z=YJ2knuYoK8thevVpL+bv+kb=QKN4Pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I finally backed up all my data, and switched from a RAID5 with spare
to a RAID6.

After putting back the data, I performed a check on my RAID array.
Note that it was with a timeout of 30".

In the dmesg, I noticed a bunch (92 !) of read errors.

[113036.865662] ata3.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0=
x0
[113036.865671] ata3.00: irq_stat 0x40000008
[113036.865679] ata3.00: failed command: READ FPDMA QUEUED
[113036.865692] ata3.00: cmd 60/00:00:88:ab:c5/04:00:e3:00:00/40 tag 0
ncq 524288 in
[113036.865692]          res 41/40:00:a8:ae:c5/00:00:e3:00:00/40 Emask
0x409 (media error) <F>
[113036.865699] ata3.00: status: { DRDY ERR }
[113036.865703] ata3.00: error: { UNC }
[113036.866993] ata3.00: configured for UDMA/133
[113036.867111] sd 2:0:0:0: [sdc] Unhandled sense code
[113036.867116] sd 2:0:0:0: [sdc]
[113036.867120] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[113036.867124] sd 2:0:0:0: [sdc]
[113036.867127] Sense Key : Medium Error [current] [descriptor]
[113036.867134] Descriptor sense data with sense descriptors (in hex):
[113036.867137]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[113036.867153]         e3 c5 ae a8
[113036.867161] sd 2:0:0:0: [sdc]
[113036.867167] Add. Sense: Unrecovered read error - auto reallocate fa=
iled
[113036.867171] sd 2:0:0:0: [sdc] CDB:
[113036.867174] Read(10): 28 00 e3 c5 ab 88 00 04 00 00
[113036.867189] end_request: I/O error, dev sdc, sector 3821383336
[113036.867240] ata3: EH complete

They all are on the same drive : sdc (WD Red).

Here is a "smarctl -a /dev/sdc" : http://pastie.org/8491779

It's a recent drive (3000 hours =3D> 4 months), is it currently dying ?

Thanks,

gUI

--=20
Pour la sant=C3=A9 de votre ordinateur, pr=C3=A9f=C3=A9rez les logiciel=
s libres.
Lire son mail : http://www.mozilla-europe.org/fr/products/thunderbird/
Browser le web : http://www.mozilla-europe.org/fr/products/firefox/
Suite bureautique : http://www.libreoffice.org/download/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
