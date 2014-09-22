From: Ian Young <ian@duffrecords.com>
Subject: not enough operational mirrors
Date: Sun, 21 Sep 2014 22:32:19 -0700
Message-ID: <CANs+QMzWWqh-5MemOrbguaq7fNzJPDaYUH66K0rgGrnaXY7FNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My 6-drive software RAID 10 array failed.  The individual drives
failed one at a time over the past few months but it's been an
extremely busy summer and I didn't have the free time to RMA the
drives and rebuild the array.  Now I'm wishing I had acted sooner
because three of the drives are marked as removed and the array
doesn't have enough mirrors to start.  I followed the recovery
instructions at raid.wiki.kernel.org and, before making things any
worse, saved the status using mdadm --examine and consulted this
mailing list.  Here's the status:

http://pastebin.com/KkV8e8Gq

I can see that the event counts on sdd2 and sdf2 are significantly far
behind, so we can consider that data too old.  sdc2 is only behind by
two events, so any data loss there should be minimal.  If I can make
the array start with sd[abce]2 I think that will be enough to mount
the filesystem, back up my data, and start replacing drives.  How do I
do that?
