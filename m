From: Ninti Systems <office@ninti.com.au>
Subject: RE: Please review: Slackware RAID How-To
Date: 21 May 2004 12:17:37 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1085107657.1945.31.camel@localhost>
References: <200405200502.i4K52rB18138@www.watkins-home.com>
	 <1085039936.10231.74.camel@localhost>
Reply-To: office@ninti.com.au
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1085039936.10231.74.camel@localhost>
To: John Lange <john.lange@bighostbox.com>
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Further to my last posting re RAID1 on Slackware 9.1 using the "Lange
Method":

Building extra arrays after booting into the installed system seems to
work as expected. It just means that "core" filesystems like /var or
/tmp can't be easily installed across more than 4 raid arrays during
setup. I guess that some filesystem copying and fstab editing might
solve this if really necessary.

How/where can I access the raidtab file on the install CD during setup?
This would be a good point to include in the HOW-TO.

Mick


