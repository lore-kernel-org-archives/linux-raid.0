From: Ninti Systems <office@ninti.com.au>
Subject: RE: Please review: Slackware RAID How-To
Date: 21 May 2004 11:55:15 +0930
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1085106315.1945.25.camel@localhost>
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

Here's a couple more Slackware RAID1 tidbits:

I'm building another RAID1 array right now on Slackware 9.1 using the
"Lange Method" :-)

1. I omitted "chunk-size" from /etc/raidtab, and got an error message. I
had to add it before I could proceed. I suppose that answers my own "is
chnk-size really necessary for RAID1" question. I went for size=4.

2. I am trying to create 5 devices (/dev/md0 to /dev/md4). The /dev/
directory (the one on the install CD I suppose it must be) only has 4 md
devices (0 to 3). I tried creating an extra /dev/md4, but couldn't make
it happen. An installed system has 16 possible md devices. 

Mick



