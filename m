From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: Few questions
Date: Fri, 7 Dec 2007 22:17:18 -0500
Message-ID: <200712080317.lB83HNn29385@www.watkins-home.com>
References: <4759E13F.7000308@makuch.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4759E13F.7000308@makuch.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Michael Makuch' <linuxraid@makuch.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

man md
man mdadm

I use RAID6.  Happy with it so far, but haven't had a disk failure yet.
RAID5 sucks because if you have 1 failed disk and 1 bad block on any other
disk, you are hosed.

Hope that helps.

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Michael Makuch
} Sent: Friday, December 07, 2007 7:12 PM
} To: linux-raid@vger.kernel.org
} Subject: Few questions
} 
} I realize this is the developers list and though I am a developer I'm
} not a developer
} of linux raid, but I can find no other source of answers to these
} questions:
} 
} I've been using linux software raid (5) for a couple of years, having
} recently uped
} to the 2.6.23 kernel (FC7, was previously on FC5). I just noticed that
} my /proc/mdstat shows
} 
} $ cat /proc/mdstat
} Personalities : [raid6] [raid5] [raid4]
} md0 : active raid5 etherd/e0.0[0] etherd/e0.2[9](S) etherd/e0.9[8]
} etherd/e0.8[7] etherd/e0.7[6] etherd/e0.6[5] etherd/e0.5[4]
} etherd/e0.4[3] etherd/e0.3[2] etherd/e0.1[1]
}       3907091968 blocks level 5, 64k chunk, algorithm 2 [9/9] [UUUUUUUUU]
}       [============>........]  resync = 64.5% (315458352/488386496)
} finish=2228.0min speed=1292K/sec
} unused devices: <none>
} 
} and I have no idea where the raid6 came from. The only thing I've found
} on raid6
} is a wikipedia.org page, nothing on
} http://tldp.org/HOWTO/Software-RAID-HOWTO.html
} 
} So my questions are:
} 
} - Is raid6 documented anywhere? If so, where? I'd like to take advantage
} of it if
} it's really there.
} - Why does my array (which I configured as raid5) have personalities of
} raid6 (I can understand why raid4 would be there)?
} - Is this a.o.k for a raid5 array?
} 
} Thanks
} -
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

