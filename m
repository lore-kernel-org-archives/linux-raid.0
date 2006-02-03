From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID 16?
Date: Thu, 2 Feb 2006 19:20:10 -0500
Message-ID: <200602030020.k130KGq13372@www.watkins-home.com>
References: <drtjq9$4le$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <drtjq9$4le$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mario 'BitKoenig' Holbe' <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

He can loose 1 disk from any 2 RAID1 arrays.  And then 2 disks from the
other 2 RAID1 arrays.  A total of 6 of 8 disks can fail if chosen correctly.

I would go with an 8 disk RAID6, which would give the space of 6 disks and
support any 2 disks failing.  Or a 7 disk RAID6 with 1 spare, but I think
that is over kill.

Guy

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Mario 'BitKoenig' Holbe
} Sent: Thursday, February 02, 2006 1:42 PM
} To: linux-raid@vger.kernel.org
} Subject: Re: RAID 16?
} 
} Matthias Urlichs <smurf@smurf.noris.de> wrote:
} > Hi, David Liontooth wrote:
} >>   * define 4 pairs of RAID 1 with an 8-port 3ware 9500S card * the OS
} will
} > Hmm. You'd have eight disks, five(!) may fail at any time, giving you
} 
} Four, isn't it?
} RAID6 covers the failure of 2 of the underlying RAID1s, which, in turn,
} means failures of 2 disks each, so four.
} Sometimes even 5, yes - given the right ones fail.
} 
} 
} regards
}    Mario
} --
} We are the Bore. Resistance is futile. You will be bored.
} 
} -
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

