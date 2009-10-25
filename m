From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: Is My Data DESTROYED?!
Date: Sun, 25 Oct 2009 17:21:43 +1100
Message-ID: <4AE3EE77.5090205@eyal.emu.id.au>
References: <20091025023059520.QFQH17264@cdptpa-omta04.mail.rr.com> <200910242326.07365.tfjellstrom@shaw.ca> <E91E45A9B1BA49A0B4CB519A91F4494C@m5>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E91E45A9B1BA49A0B4CB519A91F4494C@m5>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy,

'tar -R' does list the block# where a file starts (effectively an index).
You then forward to the file-mark of your file and therein you seek to
the desired block#. Other archiving tools also do this (e.g. afio which
I prefer).

I used a script that automatically greps the tar listing to extract this
info and extract the desired file from the tape. A few minues is all it
took.

But I use disks for backup these days...

cheers

Guy Watkins wrote:
> } -----Original Message-----
> } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> } owner@vger.kernel.org] On Behalf Of Thomas Fjellstrom
> } Sent: Sunday, October 25, 2009 1:26 AM
> } To: linux-raid@vger.kernel.org
> } Subject: Re: Is My Data DESTROYED?!
> } 
> } On Sat October 24 2009, Leslie Rhorer wrote:
  [trim]
> } Wouldn't you use some 'tar' like format on the tape so there's a file
> } index
> } you can search without having to scan the entire tape? Then you can just
> } "ffwd" (seek) to the position. _should_ be lots faster than reading all of
> } the
> } data from the beginning to the files location trying to find it. Or maybe
> } there's something I'm missing about tapes?
> 
> tar does not have an index.  The file name comes just before the file.  I
> use cpio and gzip.  But I write to a USB disk.  I have restored 1 file, and
> it had to scan through the data to find the file.
[trim]

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
