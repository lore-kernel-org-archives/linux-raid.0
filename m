From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: Interesting article
Date: Wed, 14 Jan 2009 19:57:38 -0500
Message-ID: <690282F04F6144E69BEE18546053E6DC@m5>
References: <496E44DE.7090200@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496E44DE.7090200@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Maurice Hilarius' <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Maurice Hilarius
} Sent: Wednesday, January 14, 2009 3:03 PM
} To: linux-raid@vger.kernel.org
} Subject: Interesting article
} 
} I read this today:
} http://blogs.zdnet.com/storage/?p=162
} 
} Would anyone who knows enough about this care to comment?
} 
} Thanks in advance for any thoughts..
} 
} 
} --
} With our best regards,
} 
} //Maurice W. Hilarius         Telephone: 01-780-456-9771/
} /Hard Data Ltd.                FAX:          01-780-456-9772/
} /11060 - 166 Avenue         email:maurice@harddata.com/
} /Edmonton, AB, Canada/
} /     T5X 1Y3/

I have seen RAID5 arrays loose data because of a bad block during a rebuild
since the late 1990's.  Even on big hardware RAID systems.  I now use 3 or 4
way mirrors or RAID6.  RAID 5 is too risky for me.

Back in the 1990's we mirrored some RAID5 data, but only about 5% of it.
The really important stuff.  And that has saved the day at least once.

Daily read tests are needed, but they don't give any guarantees!

I disagree with the statement "So RAID 6 will give you no more protection
than RAID 5 does now".  Not true at all, RAID5 has always had this problem
and can't recover.  RAID6 can, even with many bad blocks.  As long as you
don't have 2 bad blocks on the same block stripe.  However, if a RAID6 has a
double disk failure and you try to recover, you now have a problem if a
block is bad on another disk, and the chances of that are good with really
big disks.

Guy

