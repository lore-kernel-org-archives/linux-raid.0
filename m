From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sat, 2 May 2009 21:23:17 -0500
Message-ID: <20090503022321795.WIPA19475@cdptpa-omta01.mail.rr.com>
References: <20090428193311920.MKKC6143@cdptpa-omta03.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090428193311920.MKKC6143@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

	For anyone who really cares (probably no one), the system has now
transferred more than half the data over from the backup to the RAID system.
I have not yet experienced a single halt.  Performance seems good (I'll test
a  lot more once the data has transferred and I can take the backup array
offline).  With the RAID array more than 40% full, creating a file takes
almost no time.  Deleting a 23G file takes less than 0.9 seconds.

