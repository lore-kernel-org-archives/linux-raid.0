From: Glyn Davies <scrumpydude@yahoo.com>
Subject: starting md0 causes system to hang (RAID5)
Date: Thu, 18 Nov 2004 22:52:16 +0000 (GMT)
Message-ID: <20041118225216.25174.qmail@web13601.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
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


=====
Best Regards
Glyn


		
___________________________________________________________ 
Win a castle for NYE with your mates and Yahoo! Messenger 
http://uk.messenger.yahoo.com
