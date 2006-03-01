From: Kasper Dupont
	<78331655489368831086@expires.02.sep.2006.kasperd.net>
Subject: No syncing after crash. Is this a software raid bug?
Date: Wed, 1 Mar 2006 13:44:33 +0100
Message-ID: <20060301124432.GA3591@hactar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a FC4 installation (upgraded from FC3) using kernel
version 2.6.15-1.1831_FC4. I see some symptoms in the software
raid, which I'm not quite happy about.

After an unclean shutdown caused by a crash or power failure,
it does not resync the md devices. I have tried comparing the
contents of the two mirrors for each of the md devices. And I
found that on the swap device, there were differences.

Isn't this a bug in the software raid? Shouldn't it always
resync after reboot, if there could possibly be any difference
between the contents on the two disks?

I know that as long as only swap is affected, it is not going
to cause data loss. But how can I be sure it is not going to
happen on file systems as well?

Should I report this as a bug in Fedora Core or did I miss
something?

--=20
Kasper Dupont -- Rigtige m=E6nd skriver deres egne backupprogrammer
#define _(_)"d.%.4s%."_"2s" /* This is my new email address */
char*_=3D"@2kaspner"_()"%03"_("4s%.")"t\n";printf(_+11,_+6,_,6,_+2,_+7,=
_+6);
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
