From: Gavin Flower <gavinflower@yahoo.com>
Subject: mdadm: recovering from an aborted reshape op - boot messages
Date: Mon, 14 Feb 2011 14:47:48 -0800 (PST)
Message-ID: <396537.54229.qm@web65106.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I did not notice this before (note: I have poor eyesight, so unless I explicitly look, I may not notice things!). but just before Fedora drops to the shell on a reboot I saw these messages (hand transcribed, so might have the odd transcription error):

/dev/md1: The filing system size (according to the superblock) is 76799952 blocks
The physical size of the device is 76799616
Either the superblock or the partition table is likely to be corrupt!

/dev/md1: UNEXPECTED INCONSISTENCY: RUN fsck manually
(i.e. without -a or -p options)

Note that original size according mdadm was not a multiple of 512KB, so I reshaped it to be the largest multiple or 512KB less than the original size.  So my second attempt to reshape, using the 512 chunk size, started okay.

Advice appreciated.


Thanks,
Gavin
--
All Adults share the Responsibility
to help Raise Today's Children,
for they are Tomorrow's Society!


      
