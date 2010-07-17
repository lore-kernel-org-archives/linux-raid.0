From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Changing Chunk Size on Array
Date: Sat, 17 Jul 2010 16:15:55 -0500
Message-ID: <CC.8D.04655.49D124C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	I'm thinking about changing the chunk size on one of my arrays in
order to potentially improve performance.  The man page rather suggests -c
is a vlaid option under Grow mode, although it doesn't specifically say
mdadm supports it under --grow.  Is it indeed supported under mdadm 2.6.7.2
and kernel 2.6.26-2?  Assuming so, I would like to know a bit more about the
change before issuing the command.  Speficialy, what are the details of the
process?  Does the entire (RAID 6) array have to be re-written, such as is
the case with adding a drive to the array?  Does the recovery start
immediately?  Can it be interrupted and then continue at a later time?

