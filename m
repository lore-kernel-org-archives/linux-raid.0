From: google@familycook1.net
Subject: Is mdadm -A safe and robust
Date: Fri,  7 Jan 2005 11:30:52 -0500
Message-ID: <1105115452.41deb93c61a9f@familycook1.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Can anyone tell me if depending on mdadm -A is a safe thing to do?  I am trying
to set up a raid 5 system to store data on.  But for some reason my system will
not autodetect the raid system at boot (I have posted another message on this).

My question on this post is:  Is it safe for my data to depend on doing a -

     mdadm -A /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1

This seams to work, but is it safe in the long run?

thank you
