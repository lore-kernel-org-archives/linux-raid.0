From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Setting up md-raid5: observations, errors, questions
Date: Sun, 2 Mar 2008 14:24:04 +0100
Message-ID: <bb145bd20803020524y7b7cca01ma0b638a430c2f2f2@mail.gmail.com>
References: <bb145bd20803020423m14efea1by6e3e38bb8d0decb8@mail.gmail.com>
	 <alpine.DEB.1.00.0803020741150.13994@p34.internal.lan>
	 <bb145bd20803020456g54be4bcbg1cf7aed132ac7944@mail.gmail.com>
	 <alpine.DEB.1.00.0803020802370.18550@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0803020802370.18550@p34.internal.lan>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-raid.ids

>  You could try to change cables and such but you've already cc'd linux-ide,
>  AFAIK it can/could be a chipset/related issue and the guys who work on NCQ
>  etc are working on the problem is the last I heard..
>
>  You should try and narrow down the problem, is it always the same drive
>  that has that problem every time?  Does it occur if you do a check on the
>  RAID 5 array or only when building?  etc..

Assuming you're talking about the HSM violation error ... I got that
exactly once (yet) in the situation described (sometime after the
writing phase of badblocks). Nothing since and certainly not the spew
others are reporting.

My primary concern now is the second problem - seems like any access
to the raid array makes the machine unusable. I can type/edit a
command at the bash prompt normally but as soon as I hit enter it just
hangs there. If the command is trivial, say cat, I might get a result
a few minutes later.

bonnie++ results are in:

Version 1.03c       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
1024k            4G           16282   5 13359   3           57373   7 149.0   0
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++ +++

Something is definitely not right ... :-(

As in, an old array of 300GB IDE Maxtors has 4x the seq writes, bus
capped (105MB/s, plain PCI) reads and 3x the IOs. And it doesn't block
the machine. Granted, there's the crypto but on my other (non-raid)
boxes the performance impact just isn't there.

Any help appreciated, as it is the box has expensive-paperweight status.

C.
