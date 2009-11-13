From: "Rhorer, Leslie" <Leslie.Rhorer@twtelecom.com>
Subject: Help - Urgent!
Date: Thu, 12 Nov 2009 22:34:58 -0600
Message-ID: <6C67593AB7C1EF4AA72A4EA1CE61DEC601D20A0D@SRVMSXMB5.ad.twtelecom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Damn!!!

	I was doing some testing at the behest of Doug, when I made a
critical error which locked up the system and now the main array won't
assemble, at all.  I issued the command

`mdadm -G /dev/md0 -b internal --bitmap-chunk=65535`

	And the system complained it was an invalid chunk-size, so I
tried:

`mdadm -G /dev/md0 -b internal --bitmap-chunk=65536`

	This time there was no error, but the command line just hung
solid.  I tired everything I could to recover, but the system just went
downhill more and more.  Finally I tried a shutdown, but even that would
not work.  I had to hit the big red switch, and now when I rebooted the
system, mdadm will not assemble the array no matter what I try.  I tried


`mdadm --assemble /dev/md0 -f`

`mdadm --assemble /dev/md0 -u xxxxxxxx:xxxxxxxxx:xxxxxx:xxxxxx`

	etc.  It just keeps saying, "No devices found for md0".  When I
issue the --examine switch, the information all looks good for all the
drives, just no RAID.  What do I do, now?

	Please respond to me at leslie.rhorer@twtelecom.com, because
with the server down I do not have access to the list.

---


The content contained in this electronic message is not intended to constitute
formation of a contract binding tw telecom.  tw telecom will be contractually
bound only upon execution, by an authorized officer, of a contract including
agreed terms and conditions or by express application of its tariffs.  This message
is intended only for the use of the individual or entity to which it is addressed. If
the reader of this message is not the intended recipient, or the employee or agent
responsible for delivering the message to the intended recipient, you are hereby
notified that any dissemination, distribution or copying of this message is strictly
prohibited. If you have received this communication in error, please notify us
immediately by replying to the sender of this E-Mail or by telephone.
