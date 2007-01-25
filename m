From: Andre Majorel <aym-xunil@teaser.fr>
Subject: Synchronous mdadm --add/--re-add operations
Date: Thu, 25 Jan 2007 23:00:32 +0100
Message-ID: <20070125220031.GA30106@aym.net2.nerim.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How do I serialise mdadm --add/--re-add calls other than by
writing some shell to poll /proc/mdstat ? Is there a way to make
mdadm synchronous i.e., waiting until the operation completes or
fails instead of starting it in the background and returning.

--=20
Andr=E9 Majorel <URL:http://www.teaser.fr/~amajorel/>
Do not use this account for regular correspondence.
See the URL above for contact information.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
