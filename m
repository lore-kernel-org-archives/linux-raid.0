From: skopel@english.fsu.edu
Subject: swap on raid 1
Date: Tue, 14 Oct 2003 07:34:57 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <2507.146.201.32.254.1066131297.squirrel@english3.fsu.edu>
Reply-To: skopel@english.fsu.edu
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have been following the discussion of swap on raid 1 and I just want to
clarify something... I have my swap on /dev/md1, which is a raid1 device
consisting of /dev/hda2 and /dev/hdc2.
If one of the drives fails (either hda or hdc), I think the swap will be
duplicated on the other and the box will continue merrily on, right?
thanks


-- 
Scott Kopel -e3
FSU English Department
850 644 6177
