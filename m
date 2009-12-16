From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: [SOLVED] RAID-10 array won't auto-assemble @ boot of a Xen Guest; Works just fine 'manually' ... Any ideas?
Date: Tue, 15 Dec 2009 21:25:40 -0500
Message-ID: <4682D2657DA742B0838DD4B7B0F67ED3@m5>
References: <babafd2f0912151558y513b589ay5e43080ef8e697d@mail.gmail.com> <babafd2f0912151705sbda2f50i84ca88433713888d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <babafd2f0912151705sbda2f50i84ca88433713888d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Ben DJ' <bendj095124367913213465@gmail.com>, 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

My guess is that is specific to your distribution.

One of my systems does not even have chkconfig (Debian).  The other does not
have boot.md (FC10).

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Ben DJ
} Sent: Tuesday, December 15, 2009 8:05 PM
} To: Linux RAID Mailing List
} Subject: [SOLVED] RAID-10 array won't auto-assemble @ boot of a Xen Guest;
} Works just fine 'manually' ... Any ideas?
} 
} Apparently, when NOT a "/" or "/boot" drive, the RAID arrays need
} 
}   chkconfig boot.md on
} 
} which, strangely, doesn't show up at all in,
} 
}   chkconfig -- list | grep -i boot
}     list: unknown service
} 
} or,
} 
}   man mdadm
}   man md
} 
} Anyway, array's started on boot now.  Hth someone.
} 
} BenDJ
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

