From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: RAID-5 Expansion
Date: Mon, 29 Aug 2005 16:12:36 -0400
Message-ID: <005901c5acd5$fff03130$bd00a8c0@NCNF5131FTH>
References: <b53b67d205082913057e3bacd3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Hoover <phoover.eml@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

EMVS supports this --

http://evms.sourceforge.net

However, in my experience -- it's really slow; and it was faster for me to 
backup the data to tape; recreate the raid and restore.

It may be faster now; that was under release v2.5.1

David M. Strang


----- Original Message ----- 
From: Patrick Hoover
To: linux-raid
Sent: Monday, August 29, 2005 4:05 PM
Subject: RAID-5 Expansion


Is the only way to increase the size of a RAID-5 array to push the
data somewhere else and create a new array including the new device?
This is the only solution I have come across so far.


-Pat
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html 

