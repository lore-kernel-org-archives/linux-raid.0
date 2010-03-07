From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: What RAID type and why?
Date: Sun, 07 Mar 2010 03:10:18 -0500
Message-ID: <DC5D908DEBF84EE68CD0F3D02CAAE49B@m5>
References: <5bdc1c8b1003061402n1281b64es9fa597b8bc714bd5@mail.gmail.com>
 <87f94c371003061433x404a8c2fgcb61f817af6ecb1@mail.gmail.com>
 <9089562724D84B3C858E337F202FF550@m5> <20100307132113.7e2c95b6@notabene.brown>
 <20100307080638.GA30126@light.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20100307080638.GA30126@light.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Keld Simonsen' <keld@keldix.com>, 'Neil Brown' <neilb@suse.de>
Cc: 'Guy Watkins' <linux-raid@watkins-home.com>, 'Greg Freemyer' <greg.freemyer@gmail.com>, 'Mark Knecht' <markknecht@gmail.com>, 'Linux-RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

} -----Original Message-----
} From: Keld Simonsen [mailto:keld@keldix.com]
} Sent: Sunday, March 07, 2010 3:07 AM
} To: Neil Brown
} Cc: Guy Watkins; 'Greg Freemyer'; 'Mark Knecht'; 'Linux-RAID'
} Subject: Re: What RAID type and why?
} 
} On Sun, Mar 07, 2010 at 01:21:13PM +1100, Neil Brown wrote:
} > On Sat, 06 Mar 2010 18:17:44 -0500
} > "Guy Watkins" <linux-raid@watkins-home.com> wrote:
} >
} > > }
} > > } At a minimum I would build a 3-disk raid 6.  raid 6 does a lot of
} i/o
} > > } which may be a problem.
} > >
} > > If he only needs 3 drives I would recommend RAID1.  Can still loose 2
} drives
} > > and you don't have the RAID6 I/O overhead.
} > >
} >
} > and as md/raid6 requires at least 4 drives, RAID1 is not just the best
} > solution to survive two failures on a 3-device array, it is the only
} solution.
} 
} Raid10 can also do it.
} 
} raid1 is in many ways obsolete and you should rather use raid10,
} which in my eyeys is just another way of doing the same conceptual thing
} as raid1.
} 
} Best regards
} keld

Are you sure RAID10 can loose 2 of 3 drives?  I did not think it worked that
way.  I thought RAID10 maintained 2 copies, not 3.  But I have never used
RAID10.

Guy

