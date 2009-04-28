From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Tue, 28 Apr 2009 14:33:13 -0500
Message-ID: <20090428193311920.MKKC6143@cdptpa-omta03.mail.rr.com>
References: <20090425074027510.YPAD9976@cdptpa-omta03.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090425074027510.YPAD9976@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

	The RAID array is at 80% on the resync, and approximately 25% of the
data has been transferred from the backups.  I believe the restore is
running so slowly because of an error I made building the LVM on the backup
system.  Rather than 4 days to recover, it looks like it's going to take 16
days, or more.  As you might imagine, I'm pretty nervous, as the backup is
not fault tolerant, and the odds against the failure of a hard drive in a 16
day period are not astronomical by any means.

	This experience has prompted me to re-think my position on the
backup system.  My thoughts previously were I could save on money and effort
by simply employing a JBOD volume managed by LVM for the backup system.
After this experience, and even with the fact once the data is all
transferred I can fix the backup system to allow proper performance (i.e.
50+ MBps, rather than the current average of about 4 MBps), I believe I will
implement a RAID 5 array on the backup system.  Still being limited by
budgetary concerns, however, I saw something here which started me thinking
again.  I'm soon going to have a number of 1T drives available for use, and
replacing the backup system's 1.5T drives with brand new 2T or 3T drives is
going to be a daunting task.  Is it possible, then to use the 1T drives
combined with a like number of 1.5T to create a number (say, 6 or so) of
2.5T LVM volumes and then use mdadm to create a RAID 5 array assembled from
the virtual volumes?  Of course, I obviously could create a RAID 50 array
from the individual discs, but them the member size would be limited to 1T,
wasting .5T of each 1.5T drive.  The difference in cost between a single
1.5T drive and five or six 3T drives is going to be pretty significant, and
using the 1T drives as an interim step hopefully might allow me to put off
buying the 3T drives until they have come down in price.  I can easily
assemble twelve TB from spare parts, which should last me well into the 3rd
quarter of next year or beyond.

	Any comments?  I know with 12 drives vs. 6 drives the liklihood of a
failure is much greater, but the RAID 5 umbrella helps, and the fact this is
a backup system means my required span of reliability is much lower than for
the main system.

