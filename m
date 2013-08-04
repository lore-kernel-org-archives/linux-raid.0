From: P Orrifolius <porrifolius@gmail.com>
Subject: Advice for recovering array containing LUKS encrypted LVM volumes
Date: Sun, 4 Aug 2013 17:49:10 +1200
Message-ID: <CAC38o7ScozDqspEH-FSyoa_W5W8s+VfYd1RTAitz574wMYqhkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I have an 8 device RAID6.  There are 4 drives on each of two
controllers and it looks like one of the controllers failed
temporarily.  The system has been rebooted and all the individual
drives are available again but the array has not auto-assembled,
presumably because the Events count is different... 92806 on 4 drives,
92820 on the other 4.

And of course the sick feeling in my stomach tells me that I haven't
got recent backups of all the data on there.


What is the best/safest way to try and get the array up and working
again?  Should I just work through
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID
?

Is there anything special I can or should do given the raid is holding
encrypted LVM volumes?  The array is the only PV in a VG holding LVs
that are LUKS encrypted, within which are (mainly) XFS filesystems.

The LVs/filesystems with the data I'd be most upset about losing
weren't decrypted/mounted at the time.  Is that likely to improve the
odds of recovery?


Thanks for your help.
