From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: [PATCH 003 of 5] md: Change ENOTSUPP to EOPNOTSUPP
Date: Sun, 30 Apr 2006 01:33:51 -0400
Message-ID: <200604300533.k3U5XvB01774@www.watkins-home.com>
References: <17492.14677.389207.321221@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17492.14677.389207.321221@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>, 'Molle Bestefich' <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Neil Brown
} Sent: Sunday, April 30, 2006 12:13 AM
} To: Molle Bestefich
} Cc: linux-raid@vger.kernel.org
} Subject: Re: [PATCH 003 of 5] md: Change ENOTSUPP to EOPNOTSUPP
} 
} On Friday April 28, molle.bestefich@gmail.com wrote:
} > NeilBrown wrote:
} > > Change ENOTSUPP to EOPNOTSUPP
} > > Because that is what you get if a BIO_RW_BARRIER isn't supported !
} >
} > Dumb question, hope someone can answer it :).
} >
} > Does this mean that any version of MD up till now won't know that SATA
} > disks does not support barriers, and therefore won't flush SATA disks
} > and therefore I need to disable the disks's write cache if I want to
} > be 100% sure that raid arrays are not corrupted?
} >
} > Or am I way off :-).
} 
} The effect of this bug is almost unnoticeable.
} 
} In almost all cases, md will detect that a drive doesn't support
} barriers when writing out the superblock - this is completely separate
} code and is correct.  Thus md/raid1 will reject any barrier requests
} coming from the filesystem and will never pass them down, and will not
} make a wrong decision because of this bug.
} 
} The only cases where this bug could cause a problem are:
}  1/ when the first write is a barrier write.  It is possible that
}     reiserfs does this in some cases.  However only this write will be
}     at risk.
}  2/ if a device changes its behaviour from accepting barriers to
}     not accepting barrier (Which is very uncommon).
} 
} As md will be rejecting barrier requests, the filesystem will know not
} to trust them and should use other techniques such as waiting for
} dependant requests to complete, and calling blkdev_issue_flush were
} appropriate.
} 
} Whether filesystems actually do this, I am less certain.

What if a disk is hot added while the filesystem is mounted.  And the new
disk does not support barriers but the old disks do?  Or you have a mix?

If the new disk can't be handled correctly, maybe md should refuse to add
it.

Guy

} 
} NeilBrown
} -
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

