From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: RAID-5 degraded mode question
Date: Wed, 16 Dec 2009 13:29:21 -0800
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C087E7EA7@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C087E7E75@SDCEXCHANGE01.ad.amcc.com> <20091216211237.GA16981@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20091216211237.GA16981@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks for the response.

>>  Also as soon as disk failed md drivers marks that drive as faulty
and 
>> continue operation in degraded mode right ? Is there a way to get out

>> the degraded mode without adding spare drive. Assuming we have 5 disk

>> system with one failed drive.
>> 
>I'm not sure what you want to happen here.  The only way to get out of
degraded mode is to replace the drive in the >array (if it's not
actually faulty then you can add it back, otherwise you need to add a
new drive).
>What were you thinking might happen otherwise?


I was thinking we can recover from this using re-sync or resize .After
running IO to degraded (RAID-5) /dev/md0, I am seeing an issue where
e2fsck reports inconsistent file system and corrects it. I am trying to
debug  to see if the issue is because of data not being written or
reading wrong data in degraded mode. 

I guess problem happening during the write. Reason is , after ran e2fsck
I don't see inconsistency any more.

Regards,
Marri

