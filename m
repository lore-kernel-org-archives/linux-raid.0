From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Please review: Slackware RAID How-To
Date: Thu, 20 May 2004 22:55:26 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405210255.i4L2tWB21950@www.watkins-home.com>
References: <1085106315.1945.25.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1085106315.1945.25.camel@localhost>
To: office@ninti.com.au, 'John Lange' <john.lange@bighostbox.com>
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

That will teach you!
mkraid and raidstart are considered obsolete by this group.
Use mdadm.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ninti Systems
Sent: Thursday, May 20, 2004 10:25 PM
To: John Lange
Cc: 'LinuxRaid'
Subject: RE: Please review: Slackware RAID How-To

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



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


