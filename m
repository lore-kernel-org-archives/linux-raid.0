From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Spinning down idle disks?
Date: Sun, 26 May 2013 12:49:54 +0200 (CEST)
Message-ID: <20231564.0.1369565394879.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all

Is it possible somehow to have linux spin down idle disks in an MD raid=
 as to use MD for a MAID (massive array of idle disks)? I tried to moni=
tor an idle raid with blktrace, and it seems the array (and its members=
) is accessed every two seconds for some reason. The array used with fo=
r the testing is a idle, degraded raid-5.

roy

root@Mathsterk:~# blktrace -d /dev/md0 -o - | blkparse -i -
  9,0    2        1     0.000000000 26793  A   W 5368711168 + 8 <- (252=
,2) 0
  9,0    2        2     0.000000879 26793  Q   W 5368711168 + 8 [(null)=
]
  9,0    1        3     0.020063084   372  C   W 5368711168 [0]
  9,0    2        3     0.020113389 26793  A WBS 0 + 0 <- (252,2) 0
  9,0    2        4     0.020114118 26793  Q WBS [kworker/u:1]
  9,0    0        1     1.999791074  6948  A WBS 0 + 0 <- (252,2) 0
  9,0    0        2     1.999792301  6948  Q WBS [kworker/u:2]
  9,0    0        3     2.000000284  6948  A   W 5368711168 + 8 <- (252=
,2) 0
  9,0    0        4     2.000001050  6948  Q   W 5368711168 + 8 [kworke=
r/u:2]
  9,0    0        5     2.020065947  6948  A WBS 0 + 0 <- (252,2) 0
  9,0    0        6     2.020066632  6948  Q WBS [kworker/u:2]
  9,0    1        4     2.020018632   372  C   W 5368711168 [0]
  9,0    0        7     3.999790266 26793  A WBS 0 + 0 <- (252,2) 0
  9,0    0        8     3.999791552 26793  Q WBS [kworker/u:1]
  9,0    0        9     4.000000435 26793  A   W 5368711168 + 8 <- (252=
,2) 0
  9,0    0       10     4.000001135 26793  Q   W 5368711168 + 8 [kworke=
r/u:1]
  9,0    0       11     4.020027371 26793  A WBS 0 + 0 <- (252,2) 0
  9,0    0       12     4.020028051 26793  Q WBS [kworker/u:1]
  9,0    1        5     4.019973885   372  C   W 5368711168 [0]
  9,0    0       13     5.999788009  6948  A WBS 0 + 0 <- (252,2) 0
  9,0    0       14     5.999789265  6948  Q WBS [kworker/u:2]
  9,0    0       15     5.999999943  6948  A   W 5368711168 + 8 <- (252=
,2) 0
  9,0    0       16     6.000000676  6948  Q   W 5368711168 + 8 [kworke=
r/u:2]
  9,0    0       17     6.019936327  6948  A WBS 0 + 0 <- (252,2) 0
  9,0    0       18     6.019937059  6948  Q WBS [kworker/u:2]
  9,0    1        6     6.019883619   372  C   W 5368711168 [0]
  9,0    2        5     8.019890546   372  C   W 5368711168 [0]
  9,0    0       19     7.999785408 26793  A WBS 0 + 0 <- (252,2) 0
  9,0    0       20     7.999786808 26793  Q WBS [kworker/u:1]
  9,0    0       21     7.999997589 26793  A   W 5368711168 + 8 <- (252=
,2) 0
  9,0    0       22     7.999998282 26793  Q   W 5368711168 + 8 [kworke=
r/u:1]
  9,0    0       23     8.019948314 26793  A WBS 0 + 0 <- (252,2) 0
  9,0    0       24     8.019949033 26793  Q WBS [kworker/u:1]


--=20
Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
