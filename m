From: "Guy Watkins" <guy@watkins-home.com>
Subject: RE: How many drives are bad?
Date: Tue, 19 Feb 2008 19:22:51 -0500
Message-ID: <200802200123.m1K1N9E16012@www.watkins-home.com>
References: <1bbd01c8732f$e115f970$0603a8c0@meanmachine>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1bbd01c8732f$e115f970$0603a8c0@meanmachine>
Sender: linux-raid-owner@vger.kernel.org
To: 'Steve Fairbairn' <steve@fairbairn-family.com>, 'Norman Elton' <normelton@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Steve Fairbairn
} Sent: Tuesday, February 19, 2008 2:45 PM
} To: 'Norman Elton'
} Cc: linux-raid@vger.kernel.org
} Subject: RE: How many drives are bad?
} 
} 
} >
} > The box presents 48 drives, split across 6 SATA controllers.
} > So disks sda-sdh are on one controller, etc. In our
} > configuration, I run a RAID5 MD array for each controller,
} > then run LVM on top of these to form one large VolGroup.
} >
} 
} I might be missing something here, and I realise you'd lose 8 drives to
} redundancy rather than 6, but wouldn't it have been better to have 8
} arrays of 6 drives, each array using a single drive from each
} controller?  That way a single controller failure (assuming no other HD
} failures) wouldn't actually take any array down?  I do realise that 2
} controller failures at the same time would lose everything.

Wow.  Sounds like what I said a few months ago.  I think I also recommended
RAID6.

Guy

} 
} Steve.
} 
} No virus found in this outgoing message.
} Checked by AVG Free Edition.
} Version: 7.5.516 / Virus Database: 269.20.7/1286 - Release Date:
} 18/02/2008 18:49
} 
} 
} -
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

