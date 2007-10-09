From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: very degraded RAID5, or increasing capacity by adding discs
Date: Mon, 8 Oct 2007 21:53:24 -0400
Message-ID: <200710090153.l991rTV15210@www.watkins-home.com>
References: <20071009004636.112c886e@absurd>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071009004636.112c886e@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: 'Janek Kozicki' <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Janek Kozicki
} Sent: Monday, October 08, 2007 6:47 PM
} To: linux-raid@vger.kernel.org
} Subject: Re: very degraded RAID5, or increasing capacity by adding discs
} 
} Janek Kozicki said:     (by the date of Tue, 9 Oct 2007 00:25:50 +0200)
} 
} > Richard Scobie said:     (by the date of Tue, 09 Oct 2007 08:26:35
} +1300)
} >
} > > No, but you can make a degraded 3 drive array, containing 2 drives and
} > > then add the next drive to complete it.
} > >
} > > The array can then be grown (man mdadm, GROW section), to add the
} fourth.
} >
} > Oh, good. Thanks, I must've been blind that I missed this.
} > This completely solves my problem.
} 
} Uh, actually not :)
} 
} My 1st 500 GB drive is full now. When I buy a 2nd one I want to
} create a 3-disc degraded array using just 2 discs, one of which
} contains unbackupable data.
} 
} steps:
} 1. create degraded two-disc RAID5 on 1 new disc
} 2. copy data from old disc to new one
} 3. rebuild the array with old and new discs (now I have 500 GB on 2 discs)
3. Add old disk to new array.  Once done RAID5 is redundant.

} 4. GROW this array to a degraded 3 discs RAID5 (so I have 1000 GB on 2
} discs)
4. Buy 3rd disk.
5. Add new 3rd disk to array and grow to 3 disk RAID5 array.  Once done,
array is redundant.

Repeat 4 and 5 each time you buy a new disk.

I don't think you can grow to a degraded array.  I think you must add a new
disk first.  But I am not sure.

} ...
} 5. when I buy 3rd drive I either grow the array, or just rebuild and
} wait with growing until I buy a 4th drive.
} 
} Problems at step 4.: 'man mdadm' doesn't tell if it's possible to
} grow an array to a degraded array (non existant disc). Is it possible?
} 
} 
} PS: the fact, that degraded array will be unsafe for the data is an
} intented motivating factor for buying next drive ;)
} 
} --
} Janek Kozicki                                                         |
} -
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

