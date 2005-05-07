From: Bradley Baetz <bbaetz@acm.org>
Subject: Re: mdadm oddity.
Date: Sun, 08 May 2005 09:51:56 +1000
Message-ID: <d5jjtn$96j$1@sea.gmane.org>
References: <cone.1115508816.149032.5308.500@commodore.email-scan.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080408070902000203050901"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cone.1115508816.149032.5308.500@commodore.email-scan.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080408070902000203050901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This happens if you don't have a spares= line in mdadm.conf; the code 
defaults it to a massive number.

Try the attached patch, which I've sent to Neil a couple of times.

Bradley

Sam Varshavchik wrote:
> I noticed a slight oddity on one of my servers: when I start "mdadm 
> --monitor --scan" I get only the "NewArray" message.  On the other 
> server I get a "NewArray" then a "SparesMissing" message, for each RAID 
> partition.  Neither server has spares.  Both servers have a pair of SCSI 
> drives in a RAID-1 configuration for all of the partitions.
> 
> Well, the real oddity is actually that the other server only reports a 
> NewArray -- because I see in the ChangeLog mdadm is _supposed_ to report 
> both NewArray and SparesMissing.  But until I turned up the second 
> server I only ever got NewArray from mdadm, so that was something new.
> 
> Investigating this I discovered that I get a SparesMissing message if I 
> explicitly enumerate all my RAID partitions in mdadm.conf (mdadm 
> 1.5.0).  If I don't list my partitions in mdadm.conf, mdadm still finds 
> them, but then reports only a NewArray message.  Does that sound right?
> 
> 


--------------080408070902000203050901
Content-Type: text/x-patch;
 name="mdadm-sparesmissing.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdadm-sparesmissing.patch"

--- config.c.orig       Sun Jun 27 23:55:57 2004
+++ config.c    Sun Jun 27 23:58:21 2004
@@ -270,7 +270,7 @@
 	mis.super_minor = UnSet;
 	mis.level = UnSet;
 	mis.raid_disks = UnSet;
-	mis.spare_disks = UnSet;
+	mis.spare_disks = 0;
 	mis.devices = NULL;
 	mis.devname = NULL;
 	mis.spare_group = NULL;

--------------080408070902000203050901--

