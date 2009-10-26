From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: Is My Data DESTROYED?!
Date: Sun, 25 Oct 2009 22:40:03 -0400
Message-ID: <EFC965352E0D46AE8F849753A9602B71@m5>
References: <54075B33AEE94E7E965ACB64C976007E@m5> <20091026013607008.UDPS5890@cdptpa-omta01.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091026013607008.UDPS5890@cdptpa-omta01.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Leslie Rhorer' <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Leslie Rhorer
} Sent: Sunday, October 25, 2009 9:36 PM
} To: linux-raid@vger.kernel.org
} Subject: RE: Is My Data DESTROYED?!
} 
} > Cool, I learned something.  Thanks.
} >
} > I use disks too.  Could "seek" using dd, but I also gzip my stuff and
} use
} > cpio.  :(  Anyway, I almost never need to restore a file.  :)
} 
} 	I rather like fbackup combined with gzip, but I don't know if there
} is a Linux port of fbackup.  I use fbackup to create a named index for
} each
} backup set, whether on disk or tape.  This makes it easy to see if a
} particular file is on an archive without having to load the archive.
} 

Where do you keep this index?  Hopefully not on the disk that needs to be
restored.  :)

I thought about it, for my needs I don't need an index.  You don't need an
index for a full restore and I only need to restore once every few years.
And so far, never needed a full restore, just a file or so.  I can live with
a few hours to restore 1 file.  But I really need a faster backup.  My 500GB
USB disks gives me about 15 MB/sec.  I don't know why it is so slow.  Should
be able to do 40+.

Oh, I did have a 22 tape library with a DLT-8000.  But it failed a few years
ago.  Was really cool, but took forever to backup 300-400GB.  I guess my USB
disk is about the same speed, and it takes forever too.

