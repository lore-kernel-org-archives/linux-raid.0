From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: Is My Data DESTROYED?!
Date: Sun, 25 Oct 2009 18:55:01 -0400
Message-ID: <54075B33AEE94E7E965ACB64C976007E@m5>
References: <20091025023059520.QFQH17264@cdptpa-omta04.mail.rr.com> <200910242326.07365.tfjellstrom@shaw.ca> <E91E45A9B1BA49A0B4CB519A91F4494C@m5> <4AE3EE77.5090205@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE3EE77.5090205@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Eyal Lebedinsky' <eyal@eyal.emu.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cool, I learned something.  Thanks.

I use disks too.  Could "seek" using dd, but I also gzip my stuff and use
cpio.  :(  Anyway, I almost never need to restore a file.  :)

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Eyal Lebedinsky
} Sent: Sunday, October 25, 2009 2:22 AM
} To: linux-raid@vger.kernel.org
} Subject: Re: Is My Data DESTROYED?!
} 
} Guy,
} 
} 'tar -R' does list the block# where a file starts (effectively an index).
} You then forward to the file-mark of your file and therein you seek to
} the desired block#. Other archiving tools also do this (e.g. afio which
} I prefer).
} 
} I used a script that automatically greps the tar listing to extract this
} info and extract the desired file from the tape. A few minues is all it
} took.
} 
} But I use disks for backup these days...
} 
} cheers
} 
} Guy Watkins wrote:
} > } -----Original Message-----
} > } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} > } owner@vger.kernel.org] On Behalf Of Thomas Fjellstrom
} > } Sent: Sunday, October 25, 2009 1:26 AM
} > } To: linux-raid@vger.kernel.org
} > } Subject: Re: Is My Data DESTROYED?!
} > }
} > } On Sat October 24 2009, Leslie Rhorer wrote:
}   [trim]
} > } Wouldn't you use some 'tar' like format on the tape so there's a file
} > } index
} > } you can search without having to scan the entire tape? Then you can
} just
} > } "ffwd" (seek) to the position. _should_ be lots faster than reading
} all of
} > } the
} > } data from the beginning to the files location trying to find it. Or
} maybe
} > } there's something I'm missing about tapes?
} >
} > tar does not have an index.  The file name comes just before the file.
} I
} > use cpio and gzip.  But I write to a USB disk.  I have restored 1 file,
} and
} > it had to scan through the data to find the file.
} [trim]
} 
} --
} Eyal Lebedinsky	(eyal@eyal.emu.id.au)
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

