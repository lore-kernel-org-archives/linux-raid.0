From: George Rapp <george.rapp@gmail.com>
Subject: Recommended filesystem for RAID 6
Date: Tue, 11 Aug 2020 00:42:33 -0400
Message-ID: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Linux RAID community -

I've been running an assortment of software RAID arrays for a while
now (my oldest Creation Time according to 'mdadm --detail' is April
2011) but have been meaning to consolidate my five active arrays into
something easier to manage. This weekend, I finally found enough cheap
2TB disks to get started. I'm planning on creating a RAID 6 array due
to the age and consumer-grade quality of my 16 2TB disks.

Use case is long-term storage of many small files and a few large ones
(family photos and videos, backups of other systems, working copies of
photo, audio, and video edits, etc.)? Current usable space is about
10TB but my end state vision is probably upwards of 20TB. I'll
probably consign the slowest working disks in the server to an archive
filesystem, either RAID 1 or RAID 5, for stuff I care less about and
backups; the archive part can be ignored for the purposes of this
exercise.

My question is: what filesystem type would be best practice for my use
case and size requirements on the big array? (I have reviewed
https://raid.wiki.kernel.org/index.php/RAID_and_filesystems, but am
looking for practitioners' recommendations.)  I've run ext4
exclusively on my arrays to date, but have been reading up on xfs; is
there another filesystem type I should consider? Finally, are there
any pitfalls I should know about in my high-level design?

Details:
# uname -a
Linux backend5 5.7.11-200.fc32.x86_64 #1 SMP Wed Jul 29 17:15:52 UTC
2020 x86_64 x86_64 x86_64 GNU/Linux
# mdadm --version
mdadm - v4.1 - 2018-10-01

Finally, and this is inadequate given the value I've received from the
efforts of this group, but thanks for many years of supporting mdadm
and helping with software RAID issues, including the recovery
procedures you have written up and guided me through. This group's
efforts have saved my data, my bacon, and my sanity on more than one
occasion.
--
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
