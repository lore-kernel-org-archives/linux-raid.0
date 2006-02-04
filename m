From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: ludicrous speed: raid6 reconstruction
Date: Fri, 3 Feb 2006 19:03:11 -0500
Message-ID: <200602040003.k1403Gq17507@www.watkins-home.com>
References: <43E3D174.3090608@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43E3D174.3090608@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mike Hardy' <mhardy@h3c.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Don't forget, that speed is per disk!  :)

In about 10 years we will laugh at how slow this is.

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Mike Hardy
} Sent: Friday, February 03, 2006 4:56 PM
} To: linux-raid@vger.kernel.org
} Subject: Re: ludicrous speed: raid6 reconstruction
} 
} 
} I saw this on my array, and other(s) have reported it as well.
} 
} Apparently the reconstruction speed algorithm doesn't understand that
} it's not syncing all the blocks and hilarity ensues. I believe that was
} it, anyway
} 
} Either that or you really have a hell of a server :-)
} 
} -Mike
} 
} jurriaan wrote:
} > Personalities : [linear] [raid0] [raid1] [raid5] [raid4] [raid6]
} > md0 : active raid6 sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2]
} sdb1[1] sda1[0]
} >       1465175424 blocks level 6, 64k chunk, algorithm 2 [8/8] [UUUUUUUU]
} >       [==================>..]  resync = 91.0% (222239104/244195904)
} finish=0.0min speed=7369041K/sec
} >       bitmap: 23/233 pages [92KB], 512KB chunk
} > I am reminded of Spaceball's 'ludicrous speed' here. This is after a
} > reboot from 2.6.16-rc1-mm3 (where the array was built) to 2.6.16-rc1-mm5
} > (where rebuilding continued thanks to the bitmap).
} -
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

