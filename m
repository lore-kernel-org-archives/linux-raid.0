From: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Subject: problem with software raid1 on 2.6.22.10: check/rebuild hangs
Date: Mon, 3 Dec 2007 03:05:50 +0100
Message-ID: <200712030305.50109.wolfgang.walter@studentenwerk.mhn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, mingo@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

with kernel 2.6.22.10 checking a raid1 or rebuilding ist does not work =
on one=20
of our machines. After a short time the rebuild/check does not make pro=
gress=20
any more . Processes which then access the filesystems on those raids a=
re=20
blocked.

Nothing gets logged. Access to other filesystems works fine.

If we boot 2.6.17.10 (the kernel we used befor upgrading to 2.6.22) the=
 raids=20
the check/rebuild is done without any problems.

The filesystems on the raid are exported via nfs.

The machine has 2 xeons with hyperthreading.

Regards,
--=20
Wolfgang Walter
Studentenwerk M=FCnchen
Anstalt des =F6ffentlichen Rechts
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
