From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Converting a non-RAID RedHat System to run on Software RAID
Date: Tue, 9 Sep 2003 14:37:18 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E5DA6395B8F9614EB7A784D628184B200D9A56@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Eric Wood <eric@interplas.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here's my current info on how to build a root mirror with software RAID.
   http://scsirastools.sourceforge.net/docs/UserGuide (section 4.0)
I used the HOWTO, with some things added that I learned along the way.
The 15 steps are scripted, and the scripts are broken out in the CVS
tree as files/md*.sh

The instructions are oriented to lilo, but the grub equivalent is
scripted in files/mdevt script:
http://cvs.sourceforge.net/cgi-bin/viewcvs.cgi/*checkout*/scsirastools/s
csirastools/files/mdevt?rev=HEAD&content-type=text/plain

Andy

-----Original Message-----
From: Eric Wood [mailto:eric@interplas.com] 
Sent: Tuesday, September 09, 2003 2:18 PM
To: linux-raid@vger.kernel.org
Subject: Converting a non-RAID RedHat System to run on Software RAID


I frequently want to convert an existing single drive install of RH
linux
into a mirrored RAID-1 set.  So I thought I found the holy grail:

http://unthought.net/Software-RAID.HOWTO/Software-RAID.HOWTO-4.html#ss4.
14

However, it is slightly out dated (RH 7.1 days).  Since I'm trying to
mirror
RH 9, I have several questions based on this HOWTO:

1. Sect. 4.14.6: /dev/md0 already existed while in rescue mode.  Ignored
it,
no problem
2. Sect. 4.14.7: I could not umount /mnt/sysimage to save my life.
Looking
at what was mounted, I seen that I needed to also umount
/mnt/sysimage/dev/pts.  I cd'd into the / directory to make sure I
wasn't
holding the unmount up.  So I could not proceed with the howto.

3. Sect. 4.14.11,12 should be updated to include grub.

4. Sect. 4.14.14.  Do I first have to convert from ext3 back to ext2?
Since
I use ext3 does this step still apply or does mkraid at the second
superblock in an acceptable manor for ext3?  Do I still have to
resize2fs
the md devices?

Any info I gather, I will relay to the howto author and hopefully he'll
come
out with an update.
thanks,
-eric wood

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
