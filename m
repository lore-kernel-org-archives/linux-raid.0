From: Tom De Mulder <tdm27@cam.ac.uk>
Subject: Re: Software RAID and TRIM
Date: Wed, 29 Jun 2011 11:32:55 +0100 (BST)
Message-ID: <alpine.OSX.2.00.1106291119200.257@trogdor.csi.cam.ac.uk>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="140733193388032-1471375585-1309342982=:257"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>
Content-ID: <alpine.OSX.2.00.1106291131540.257@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--140733193388032-1471375585-1309342982=:257
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15; FORMAT=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.OSX.2.00.1106291131541.257@trogdor.csi.cam.ac.uk>

On Tue, 28 Jun 2011, Mathias Bur=E9n wrote:

> IIRC md can already pass TRIM down, but I think the filesystem needs
> to know about the underlying architecture, or something, for TRIM to
> work in RAID.

Yes, it's (usually/ideally) the filesystem's job to invoke the TRIM=20
command, and that's what ext4 can do. I have it working just fine on=20
single drives, but for reasons of service reliability would need to get=20
RAID to work.

I tried (on an admittedly vanilla Ubuntu 2.6.38 kernel) the same on a two=
=20
drive RAID1 md and it definitely didn't work (the blocks didn't get marked=
=20
as unused and zeroed).

> There's numerous discussions on this in the archives of
> this mailing list.

Given how fast things move in the world of SSDs at the moment, I wanted to=
=20
check if any progress was made since. :-) I don't seem to be able to find=
=20
any reference to this in recent kernel source commits (but I'm a complete=
=20
amateur when it comes to git).


Thanks,

--
Tom De Mulder <tdm27@cam.ac.uk> - Cambridge University Computing Service
+44 1223 3 31843 - New Museums Site, Pembroke Street, Cambridge CB2 3QH
-> 29/06/2011 : The Moon is Waning Crescent (18% of Full)
--140733193388032-1471375585-1309342982=:257--
