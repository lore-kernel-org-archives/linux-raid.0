From: "John Stoffel" <john@stoffel.org>
Subject: Re: upgrading a RAID array in-place with larger drives.  request for
 review of my approach?
Date: Sun, 30 Nov 2014 22:28:48 -0500
Message-ID: <21627.57456.206853.819767@quad.stoffel.home>
References: <1417402553.1412807.197119853.0D7A911E@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1417402553.1412807.197119853.0D7A911E@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: terrygalant@mailbolt.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Terry,

If you have the ability and the power and space in the chassis, i'd
just add in the four new drives, set them up in their RAID10 format,
then just do a 'pvmove' to migrate all our currently LVs from the old
1Tb RAID10 setup to the new one.  No fuss, no muss and you can keep
the system online while doing it.  

You will of course need to add in the new disks into the VG, but
that's simple to do.  Once all the data is moved off the old disks,
you can then remove them from the VG and then shutdown the MD device
,and then remove the disks from the system.  

Let me know if you need more details, I glossed over a bunch here.

John

