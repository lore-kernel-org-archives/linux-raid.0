From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: Is My Data DESTROYED?!
Date: Fri, 23 Oct 2009 18:36:37 -0400
Message-ID: <74E373EB1DE44CEA9EC301F51C20C7D6@m5>
References: <Pine.GSO.4.64.0910232250100.5182@montezuma.acc.umu.se> <818410.23525.qm@web38801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <818410.23525.qm@web38801.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You can buy a 1TB disk for less than $100.  A 10TB backup would cost less
than $1000.

I backup to an external USB disk.  If I required more than 1 I would create
a RAID5 with USB disks.  If I was really careful, I would have 2 or more
disks and rotate them off site.  Maybe my Mom's house.  No, my car would do
just fine.

Fact:  I don't think you read the archives.  If you did, you would remove
the failed drive from the array and add it back.  And you would have
included some debugging info in 1 of your first 5 posts.  But you just
spammed the list with noise.

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of adfas asd
} Sent: Friday, October 23, 2009 5:56 PM
} To: linux-raid@vger.kernel.org
} Subject: Re: Is My Data DESTROYED?!
} 
} For those of you who don't follow the list closely, we have gone over this
} same old ground several times already.
} 
} - Of course I know that RAID is not quite as good as backup.
} - Of course I wish that backing up could save many terabytes of data for
} less than $10,000.  But that is not practical today.
} 
} Fact:  I have terabytes of data that I want to keep from losing.
} Fact:  Disk drives have never been cheaper.
} Fact:  It is most cost-effective to save terabytes of data on disk drives,
} if the proper regimen can be determined for safety.
} Fact:  After one month's use mdadm RAID has resulted in a failure which
} could have been catastrophic had I not determined that somehow JFS
} functionality was destroyed.
} Fact:  Now one of my  arrays has gone into degraded mode for mysterious
} reasons, and we are so busy arguing about backups that no one can advise
} on what to do about this.
} 
} 
} --- On Fri, 10/23/09, Mattias Wadenstein <maswan@acc.umu.se> wrote:
} 
} > From: Mattias Wadenstein <maswan@acc.umu.se>
} > Subject: Re: Is My Data DESTROYED?!
} > To: "Christian Pernegger" <pernegger@gmail.com>
} > Cc: linux-raid@vger.kernel.org, "adfas asd" <chimera_god@yahoo.com>
} > Date: Friday, October 23, 2009, 1:57 PM
} > On Fri, 23 Oct 2009, Christian
} > Pernegger wrote:
} >
} > >> I believe you are confusing raid with backup.
} > >
} > > For lots of people the primary role of RAID is as a
} > protection against
} > > data-loss nowadays. Backups just aren't
} > feasible/cost-effective
} > > anymore for the amounts of data involved. Sticking
} > your head in the
} > > sand and repeating that mantra doesn't change that and
} > it isn't
} > > helping.
} >
} > Well, claiming that RAID will protect your data under all
} > circumstances isn't helping either. Backups will actually
} > protect against such things as rm -rf:ing the wrong
} > directory or mkfs:ing the wrong device, etc. Things that
} > RAID will never protect against.
} >
} > And I don't see how backups aren't feasable, USB/network
} > harddrives keep pace with in-box harddrive sizes just fine.
} > Offsite backup might be trickier/costlier, so you might
} > constrain those to just the data that you would be really
} > sad to see gone if the house burns down (photo album, own
} > creations, etc).
} >
} > /Mattias Wadenstein
} > --
} > To unsubscribe from this list: send the line "unsubscribe
} > linux-raid" in
} > the body of a message to majordomo@vger.kernel.org
} > More majordomo info at  http://vger.kernel.org/majordomo-info.html
} >
} 
} 
} 
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

