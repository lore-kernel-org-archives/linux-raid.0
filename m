From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: feature suggestion to handle read errors during re-sync of raid5
Date: Mon, 01 Feb 2010 08:33:40 -0500
Message-ID: <E15146CE216E4737A20C4EC59D414720@m5>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se>
 <4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk>
 <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se>
 <4B65AD05.5050000@anonymous.org.uk>
 <alpine.DEB.1.10.1001311854530.15329@uplift.swm.pp.se>
 <4B662ED1.3060003@gmail.com>
 <alpine.DEB.1.10.1002010814080.31777@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <alpine.DEB.1.10.1002010814080.31777@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mikael Abrahamsson' <swmike@swm.pp.se>, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have always read that drives remap on failed write.
But have not read anything new in 2+ years.

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Mikael Abrahamsson
} Sent: Monday, February 01, 2010 2:16 AM
} To: Linux RAID
} Subject: Re: feature suggestion to handle read errors during re-sync of
} raid5
} 
} On Sun, 31 Jan 2010, Roger Heflin wrote:
} 
} > Bit errors seem more likely the longer a sector has set since being
} > written. I would be not expect to see errors if you read the entire
} > disk, and then reread it 1x a day for a year, but if you read the disk
} > once, let it sit spinning for a year without any reads and read it
} > again, this will almost certainly get a read error.  When you keep
} > rereading it, when the bits start to go bad the disk should move it long
} > before data loss happens, but if you only read it 1x a year, it is
} > likely that when you find the data bad there will be too many bad bits,
} > beyond being able to correct it.
} 
} Are you sure that drives today remap like that (if it tries to read it and
} only succeeds on the 5th try, it'll reallocate the sector)?
} 
} Looking at "reallocated sectors" on my drives, I've never seen this
} happen. That SMART parameter has never increased unless I had a hard UNC
} and re-wrote the sector (and a lot of the times, not even that).
} 
} --
} Mikael Abrahamsson    email: swmike@swm.pp.se
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

