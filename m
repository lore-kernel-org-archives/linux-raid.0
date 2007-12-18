From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: Raid over 48 disks
Date: Tue, 18 Dec 2007 18:50:17 -0500
Message-ID: <200712182350.lBINoMn17765@www.watkins-home.com>
References: <47682F33.7040701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47682F33.7040701@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Brendan Conoboy' <blc@redhat.com>, 'Norman Elton' <normelton@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Brendan Conoboy
} Sent: Tuesday, December 18, 2007 3:36 PM
} To: Norman Elton
} Cc: linux-raid@vger.kernel.org
} Subject: Re: Raid over 48 disks
} 
} Norman Elton wrote:
} > We're investigating the possibility of running Linux (RHEL) on top of
} > Sun's X4500 Thumper box:
} >
} > http://www.sun.com/servers/x64/x4500/
} 
} Neat- 6 8 port SATA controllers!  It'll be worth checking to be sure
} each controller has equal bandwidth.  If some controllers are on slower
} buses than others you may want to consider that and balance the md
} device layout.

Assuming the 6 controllers are equal, I would make 3 16 disk RAID6 arrays
using 2 disks from each controller.  That way any 1 controller can fail and
your system will still be running.  6 disks will be used for redundancy.

Or 6 8 disk RAID6 arrays using 1 disk from each controller).  That way any 2
controllers can fail and your system will still be running.  12 disks will
be used for redundancy.  Might be too excessive!

Combine them into a RAID0 array.

Guy

