From: Jure =?UTF-8?B?UGXEjWFy?= <pegasus@nerv.eu.org>
Subject: bio too big device dm-XX (256 > 255) on 2.6.17
Date: Thu, 9 Nov 2006 00:52:27 +0100
Message-ID: <20061109005227.73b4fd14.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

Recently I upgraded my home server. I moved EVMS volumes from 3ware hw =
mirrors (lvm2) to a md raid1 (lvm2) and am now getting lots of these er=
rors, which result in Input/output errors trying to read files from tho=
se volumes. It's kind of ugly because I have all the data, I just canno=
t read it ...

Google comes up with mails from 2003 mentioning such problems. Are ther=
e any known such problems in recent kernels or am I hitting something n=
ew here?


--=20

Jure Pe=C4=8Dar
http://jure.pecar.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
