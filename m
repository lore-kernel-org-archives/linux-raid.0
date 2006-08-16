From: Peter Greis <peter_greis@yahoo.com>
Subject: Is mdadm --create safe for existing arrays ?
Date: Wed, 16 Aug 2006 08:26:45 -0700 (PDT)
Message-ID: <20060816152645.9761.qmail@web34611.mail.mud.yahoo.com>
Reply-To: peter_greis@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I have a SuSE 10.0 raid-1 root which will not properly
boot, and I have noticed that / and /boot have
non-persistent super blocks (which I read is required
for booting).

So, how do I change / and /boot to make the super
blocks persistent ? Is it safe to run "mdadm --create
/dev/md0 --raid-devices=3D2 --level=3D1 /dev/sda1
/dev/sdb1" without loosing any data ?

regards,

Peter

PS Yes, I have googled extensively without finding a
conclusive answer.
=20

Peter Greis
freethinker gmbh
St=E4fa Switzerland

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around=20
http://mail.yahoo.com=20
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
