From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: New device for RAID array
Date: Thu, 12 May 2011 19:59:01 -0500
Message-ID: <DF.A6.28813.F428CCD4@cdptpa-omtalb.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I read through the man page for mdadm a couple of times and did not spot how
to do this.  I currently have a RAID array that I need to upgrade from 1T
drives to 3T drives.  To accomplish this, I intend to create a larger array,
but with fewer spindles, and then rsync the contents of the old array to the
new.  Once I am done, I then want to stop the old array (/dev/md0) and start
up the new array under /dev/md0.  Do I have to stop the array and then
re-create it with all the same parameters, except the device target?

