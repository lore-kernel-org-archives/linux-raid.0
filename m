From: Glyn Davies <scrumpydude@yahoo.com>
Subject: System hangs when starting RAID5
Date: Sat, 20 Nov 2004 12:15:25 +0000 (GMT)
Message-ID: <20041120121525.5520.qmail@web13608.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

Long story here but I'll just give the current
sypmtoms for the time being.

I have 4x160GB (hde to hdh) disks, RAID5. Volume
manager on top of that. System disk
(/,usr,var,boot,swap) on hda.  OS is Fedora Core2.
System died in a big lock up. Now, when booting it
hangs after announcing "Remounting root filesystem in
read-write mode". The OK prompt for this action is
never displayed. The system is locked up.

Booting FC2 disk1 as rescue disk I can mount the
volumes on the raid but after a short while 10-20s or
as soon as I try to browse into the directories the
system hangs. Booting the rescue CD but not starting
md0 is fine. Start it with raidstart and (after the
few seconds) it hangs. It looks to me as if this is
one well corrupted RAID5. Any suggestions of how this
can be fixed or at least kept alive long enough to get
some data off (possibly by not starting the
reconstruction - forgot to say the raid is dirty).

MTIA

=3D=3D=3D=3D=3D
Best Regards
Glyn


	=09
___________________________________________________________=20
Moving house? Beach bar in Thailand? New Wardrobe? Win =A310k with Yaho=
o! Mail to make your dream a reality.=20
Get Yahoo! Mail www.yahoo.co.uk/10k
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
