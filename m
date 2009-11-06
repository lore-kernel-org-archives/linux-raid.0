From: Neil Brown <nfbrown@novell.com>
Subject: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Fri, 6 Nov 2009 17:45:40 +1100
Message-ID: <19187.50708.551325.297625@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Greetings.

 About a week ago I released mdadm-3.1
 I have now 'withdrawn' it meaning that it doesn't appear on the
 kernel.org mirrors any more, and I ask people not to use it.

 The reason is that it is not as reliable at managing a raid[56]
 reshape as I thought and it can corrupt data too easily.

 In particular the 'backup' that is taken of the area being reshaped
 gets restored to the wrong location when the array is stopped in the
 middle of a reshape and reassembled.

 If anyone has used mdadm-3.1 to reshape an array and has stopped and
 restarted the array during that process (and I know some people have)
 then it is very possible that some data in that filesystem has been
 corrupted.  I would urge you do take whatever measures you can to
 check for corruption.  An fsck at the very least would be advised.

 The code in the devel-3.1 branch of my git tree
 (git://neil.brown.name/mdadm) has this bug fixed as well as a number
 of other improvements.  I will probably release it as 3.1.1 some time
 next week.

 Note that you need 2.6.32 for most of the reshape operations with the
 new code.  This is because 2.6.31 does not handle a device failure
 during reshape correctly and a subsequent crash can cause data to be
 lost.  When the needed patches appear in a 2.6.31.y stable kernel. I
 will adjust the requirement that mdadm imposes.

 A big "thank you" to everyone who tested out this code and an even
 bigger apology to anyone who has suffered data loss because of it.

NeilBrown
