From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RAID5 / 6 Growth
Date: Tue, 15 Dec 2009 23:40:48 -0600
Message-ID: <50.42.04641.7E2782B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	I just purchased 2 new drives to add to a RAID5 and RAID6 array,
respectively.  I have already added the 8th drive to the RAID5 array and
begun the growth.  The critical phase has been completed.  For safety, I
umounted the array before I started the growth processs.  At the rate the
data is being read and written to the drives, the resync is going to take a
very long time - about 4 days.  I'd rather not have the array down that
long, unless it's really necessary.  Is there any greater amount of jeopardy
to a RAID5 array during the growth (once the critical phase is complete)
than under ordinary circumstances?  That is to say, will losing a drive
during the resync wreak havoc on the data?

	Once I am done upgrading the RAID5 array, I'm going to add a drive
to the RAID6 array.  'Same question, there.  Will the loss of 2 drives
during the resync cause a loss of data?

