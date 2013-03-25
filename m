From: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Subject: Structure of a reshape backup file
Date: Mon, 25 Mar 2013 12:11:39 -0500
Message-ID: <CAPSPcXg8GXRtKZ+uZei3Uz9iFc76owD7=g8-xSVrKw4q2MVYOQ@mail.gmail.com>
References: <CAPSPcXjvFZEMxriMnJDc=K9wo161BgT8ofbpL=SuV=9v2yq3Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXjvFZEMxriMnJDc=K9wo161BgT8ofbpL=SuV=9v2yq3Gg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently had a hard system lockup at 15% of a raid5->6 reshape.  I
specified the backup file for the reshape to: /tmp/raid-backup.bak  I
did not know ubuntu deletes this folder on reboot.  I have taken the
drive with the deleted file to data recovery experts to try a last
resort of scavenging the drive for the deleted backup file.  They are
asking for a sample of the file to aid in looking for it.  I don't
have the hardware to recreate the situation with 6 additional 2tb
drives to set up, do a reshape, stop it and grab the backup file as a
sample, plus I assume most of the file is just blobs of arbitrary data
that might not be helpful.  Instead I am hoping to find some
information on the structure or identifying characteristics of the
backup files but there is no documentation which I can find about this
specifically.

Can anyone provide me with any information about the structure or any
identifying characteristics of the backup file?  Or perhaps refer me
to someone who can?
