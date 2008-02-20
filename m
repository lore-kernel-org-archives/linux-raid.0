From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: How many drives are bad?
Date: Tue, 19 Feb 2008 23:03:08 -0500
Message-ID: <200802200503.m1K53QE16204@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
Sender: linux-raid-owner@vger.kernel.org
To: 'Guy Watkins' <guy@watkins-home.com>, 'Steve Fairbairn' <steve@fairbairn-family.com>, 'Norman Elton' <normelton@gmail.com>
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

