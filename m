From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Fwd: Question / Request about timeouts of SATA harddisks [was:]devices
 get kicked from RAID about once a month
Date: Fri, 04 Jun 2010 08:35:52 +0200
Message-ID: <4C089EC8.2050504@stud.tu-ilmenau.de>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>, Dan Christensen <jdc@uwo.ca>, Neil Brown <neilb@suse.de>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

Below is the message I posted on linux-scsi regarding the timeouts.
I guess my approach is a bit different from Bill's, but my experience a=
t
work is (always getting 100% OK drives back from customers stating
they'd be broken) that the internal error-correction of disk drives
makes them fail RAIDs too often.  And that's because the read-commands
time out too early.

Stefan

-------- Original-Nachricht --------
Betreff: Question / Request about timeouts of SATA harddisks
Datum: Thu, 03 Jun 2010 08:32:45 +0200
Von: Stefan /*St0fF*/ H=FCbner  <stefan.huebner@stud.tu-ilmenau.de>
Antwort an: st0ff@npl.de
An: linux-scsi@vger.kernel.org

Dear list,

concerning RAIDs with Desktop class drives it'd be good to know if ther=
e
is any kernel-timeout-value which states, how long a diskdrive may take
to process a command.  If it doesn't respond in-time I've seen in my
logs and with many disks that the sg-eh becomes active resetting the
bus.  So somewhere there needs to be such a timeout.

The question is: can this timeout-value be found somewhere in the sysfs=
?
 If "yes" where?  If "no", can it be exported?

Suggestions for the maximum of this timeout-value:
I've read in multiple places that the internal error correction of
desktop-class drives can even take more than 2 minutes to complete.  Bu=
t
another much bigger value can be taken directly out of the
IDENTIFY_DEVICE_STRUCTURE, word 89, which states how long a
SECURITY_ERASE_UNIT command takes approximately (in minutes-see
ATA8-ACS, table 32 for the exact meaning of the value).  A in some case=
s
even longer time can be found in word 90 (time estimate for enhanced
security erase unit, table 33).

I know for sure that this command should not be issued from linux - at
least not at this state of libata.  I've done it twice on two different
Samsung HD103UJ drives to "securely erase customer data".  While
executing the command libata made the PassThru command fail within a
minute and according to syslog it unsuccessfully tried to reset the
drive.  The results were (after letting the drives run for about the
indicated 3 hours): one drive broke completely, it was never again
recognized on any computer, the other drive was recognized though, but
did not operate properly anymore.

Any comments and hints are very welcome.  All the best,
Stefan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
