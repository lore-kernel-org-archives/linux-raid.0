From: Christian Kivalo <valo@valo.at>
Subject: mdadm 1.5.0, email not being sent on all events!?
Date: Tue, 24 Feb 2004 23:43:24 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040224234324.00004fc9@valo.lan.valo.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi!

mdadm is startet in monitor mode at boot like this:

mdadm --monitor --daemonise /dev/md0 /dev/md1 /dev/md2 /dev/md3 /dev/md=
4

(i tried mdadm --monitor --scan --daemonise as  M=E5ns Rullg=E5rd sugge=
sted
in an other thread, same results)

in my /etc/mdadm.conf i got "MAILADDR root@myhostname.tld" and mdadm
tells me it is using that emailadress when starting in monitor mode.

mdadm sends one or sometimes two emails when i manually fail a disk
(mdadm --manage /dev/md3 --fail /dev/sda5), but it does not send email
on the following events:

no spare left
hotadd/rebuild
start rebuild finished

i believe this would be pretty nice feature, at least on a 800GB array
where rebuilding takes a large amount of time to complete ;)

the ANNOUNCE-1.5.0 file in mdadm source directory says:

- RebuildFinished event in monitor mode.

in syslog i get messages from md that sda5 is removed and that there is
no spare drive left to rebuild. but no email (is this expected to work?=
)

there is some more stuff:

sometimes mdadm tells me which drive failed and sometimes it won't. the
md-device is always reported correctly.

could somebody please shed some light on this, testmessages function
properly for all arrays.

if there is some more information needed i can provide that.

thanks in advance

regards
christian
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
