From: Mike Perry <mikepery@fscked.org>
Subject: Re: Hot adding active disk to RAID1? [PATCH]
Date: Tue, 10 Feb 2004 19:47:09 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040211014709.GA28357@fscked.org>
References: <20040207152948.GA17368@fscked.org> <20040207173716.GA10996@fscked.org> <1076178191.3328.32.camel@picard.intra.techwiz.ca> <20040210075406.GB15112@fscked.org> <16424.38075.333116.361351@notabene.cse.unsw.edu.au> <20040210150041.GA4868@fscked.org> <16425.23445.174722.587863@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16425.23445.174722.587863@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Thus spake Neil Brown (neilb@cse.unsw.edu.au):

> > Is there a preferred version/cvs repository that I should diff against? The
> > raidtools are kinda helter-skelter in their net presence, it seems..
> 
> Sorry, I should have been more specific.
> Patches *against mdadm* are welcome.
> I have no interest in "raid-tools" - it seems to be unmaintained.
> Patches against the lastest source tar-ball are fine.

Attached. Any plans to port that raidreconf tool into mdadm? Cause for
now, the new manpage refers people to the deprecated raidtools.

-- 
Mike Perry
Mad Computer Scientist
fscked.org evil labs

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="man.diff"

--- mdadm.8.old	Tue Feb 10 19:19:00 2004
+++ mdadm.8	Tue Feb 10 19:44:18 2004
@@ -363,7 +363,16 @@
 .TP
 .BR -a ", " --add
 '''add, or
-hotadd listed devices.
+hotadd listed devices as spare disks. 
+
+To add active disks to an array, you will need to recreate the array. If it is
+RAID1, you can often get away with recreating the array using the same
+devices, plus one more, without destroying data (creating a RAID1 device only
+overwrites the superblock).  Note that backing up the array to a regular file
+system on your new disk first is strongly recommended, but if all goes well,
+you should not have to recopy any more data. For RAID0 and RAID5, adding
+active disks will require a raid-tools 1.0 utility called raidreconf. Please
+be aware that there are risks involved with these tools, and plan accordingly.
 
 .TP
 .BR -r ", " --remove

--C7zPtVaVf+AK4Oqc--
