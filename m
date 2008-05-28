From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
Date: Wed, 28 May 2008 15:05:46 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805281504160.29755@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <20080528190242.GA5171@rap.rap.dk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-443333512-1212001546=:29755"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080528190242.GA5171@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-443333512-1212001546=:29755
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 28 May 2008, Keld J=F8rn Simonsen wrote:

> I added this in the wiki performance section.
Ok.

> I think it would have been informative if also a test with one drive in
> a non-raid setup was described.
Since the performance of bonnie++ deals with single threads/a raid1 would p=
robably closely match it but yeah I could do that sometime.

>
> Are there any particular findings you want to highlight?
Not in particular, just I could never find this information provided anywhe=
re
that showed all of the raid variation/types in one location that was easy t=
o
read.

>
> Is there some way to estimate random read and writes from this test?
The sequential input and output and re-write speeds are the most important.

>
> Are the XFS file systems completely new when running the tests?
Yes, after the creation of each array, mkfs.xfs -f /dev/md3 was run to ensu=
re
a clean mount and cron was also off throughout all testing.

>
> Best regards
> keld
---1463747160-443333512-1212001546=:29755--
