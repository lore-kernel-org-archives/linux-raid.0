From: Yu Chen <chen@hhmi.umbc.edu>
Subject: Re: Which raid card to buy for SargeD
Date: Fri, 9 Apr 2004 09:07:15 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404090905540.21639@treant.hhmi.umbc.edu>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca>
 <406B27E4.1000106@sauce.co.nz> <20040401090731.GI6923@chihiro.cern.ch>
 <406F936C.2090605@sauce.co.nz> <20040409111626.GC3257@chihiro.cern.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040409111626.GC3257@chihiro.cern.ch>
To: KELEMEN Peter <Peter.Kelemen@cern.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry, this might be a silly question, since I am new to RAID, how do I=
 do
those tests, I would like to check out our RAID.

Thanks a lot in advance!

Jeff
On Fri, 9 Apr 2004, KELEMEN Peter wrote:

> * Richard Scobie (richard@sauce.co.nz) [20040404 16:47]:
>
> > KELEMEN Peter wrote:
> > > * Richard Scobie (richard@sauce.co.nz) [20040401 08:19]:
> > > >3ware hardware RAID 10: Reads - 92.8MB/s    Writes - 88.9MB/s
> > > >Software RAID 10:  Reads - 53.7MB/s   Writes - 94.9 MB/s
>
> > > 3ware HW-RAID1, Linux SW-RAID0:	read 263 MiB/s, write 157 MiB/s
> > > 3ware HW-RAID5, Linux SW-RAID0:	read 243 MiB/s, write 135 MiB/s
> > > Linux SW-RAID5:			read 225 MiB/s, write 135 MiB/s
> > > 3ware HW-RAID10:		read 119 MiB/s, write  91 MiB/s
>
> > This array is obviously larger than the 4 disc one I have. Unfortun=
ately
> > you do not have the one result I would really like - SW-RAID10.
> > It would be interesting to see how it compares to 3ware HW-RAID10.
>
> Well, I did those tests as well for the sake of interest.
> Linux SW-RAID10:		read 221 MiB/s, write 105 MiB/s
>
> Peter
>
> --
>     .+'''+.         .+'''+.         .+'''+.         .+'''+.         .=
+''
>  Kelemen P=E9ter     /       \       /       \     Peter.Kelemen@cern=
=2Ech
> .+'         `+...+'         `+...+'         `+...+'         `+...+'
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
