From: "Simon Jackson" <sjackson@bluearc.com>
Subject: FW: Detecting errors on the RAID disks.
Date: Wed, 27 May 2009 16:28:22 +0100
Message-ID: <3D76E016F4A2A749A1EB1A3FD83E22BC0285F2F4@uk-email.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have been looking for a way of detecting whether disks used in RAID s=
ets have had errors that might indicate the drive is failing..=A0=20

I have noticed the files =A0"/sys/block/mdX/md/rY/errors".=A0 They appe=
ar to contain a count value.=A0=20

What errors are reported in this file?=A0=20

Does this provide a way of detecting a dying disk?=A0=20

Are there any better ways to achieve this?

Thanks Simon.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
