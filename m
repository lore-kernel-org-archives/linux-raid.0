From: "Dambacher, Ulf" <Ulf.Dambacher@mach.uni-karlsruhe.de>
Subject: AW: Automatic notification of failure in softRAID array?
Date: Tue, 9 Jul 2002 09:51:54 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6F5F11DC834C7F47958471A2B71DEB9F576D24@wbke2k.wbk.uni-karlsruhe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Peter Daniel <pdaniel@cardaccess.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Peter
Look for the new admin tool mdadm. It has the Option --monitor wich is =
able to do this job.

Gretings
	Ulf

-----Urspr=FCngliche Nachricht-----
Von: Peter Daniel [mailto:pdaniel@cardaccess.com.au]
Gesendet: Dienstag, 9. Juli 2002 09:19
An: 'linux-raid@vger.kernel.org'
Betreff: Automatic notification of failure in softRAID array?


Hello,

I am running a server here with Red Hat 7.1, 2.4.18 kernel, and softRAI=
D set
up on all but the root filesystem.  This server is meant to sit on a re=
mote
site where we won't be able to monitor it all the time, So I would like=
 it
to notify me if one of the disks in the RAID-1 array fails.  Is there a=
ny
integrated way of doing this, or will I need to hack together a script =
to
periodically parse the contents of /proc/mdstat and act accordingly?

Please reply to this address, as I am not a member of the mailing list =
and I
can not regularly check the archives.

Thanks for any assistance you may be able to render.


--
Peter Daniel

peter@cardaccess.com.au
Card Access Services Pty Ltd
http://www.cardaccess.com.au


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
