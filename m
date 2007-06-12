From: "Thorsten Wolf" <T_Wolf@gmx.net>
Subject: SLES 9 SP3 and mdadm 2.6.1 (via rpm)
Date: Tue, 12 Jun 2007 09:24:08 +0200
Message-ID: <20070612072408.19140@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone.

I've got a SLES9 SP3 running and I've been quite happy with it so far.

Recently, I've created a 4 disk spanning RAID-5 on our company server. Runs quite nice and we're happy with that too. I created that RAID using the SLES mdadm (1.4 I believe) package.

After discovering that there is a much newer mdadm out here (2.6.1), I decided to upgrade. It went just fine. Raid still running at 120 MB/sec.

After adding a disk to the raid, which went fine as well...... BUT:

The added disk /dev/sda1 shows up in /proc/mdstat, but does not have the "spare (s)" flag.

Plus... the --grow doesn't work...

I get the: mdadm: /dev/md0: Cannot get array details from sysfs error which has been discussed before. Can it be that this is caused by the 2.6.5-7.2xx Kernel? Any ideas?

regards,

Thorsten
-- 
Contact me on ICQ: 7656468
skype://sysfried

GMX FreeMail: 1 GB Postfach, 5 E-Mail-Adressen, 10 Free SMS.
Alle Infos und kostenlose Anmeldung: http://www.gmx.net/de/go/freemail
