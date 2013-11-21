From: John Williams <jwilliams4200@gmail.com>
Subject: Re: Triple parity and beyond
Date: Wed, 20 Nov 2013 18:46:03 -0800
Message-ID: <CAJBj3vf7Ot2oUkk6LtkWRouFqrSCKecz0yD4Ds5UGT1BL1ds5A@mail.gmail.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>
	<528BCA2D.5010500@redhat.com>
	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>
	<528D61C5.70902@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528D61C5.70902@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: James Plank <plank@cs.utk.edu>, Ric Wheeler <rwheeler@redhat.com>, Andrea Mazzoleni <amadvance@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Brown <david.brown@hesbynett.no>, David Smith <creamyfish@gmail.com>
List-Id: linux-raid.ids

For myself or any machines I managed for work that do not need high
IOPS, I would definitely choose triple- or quad-parity over RAID 51 or
similar schemes with arrays of 16 - 32 drives.

No need to go into detail here on a subject Adam Leventhal has already
covered in detail in an article "Triple-Parity RAID and Beyond" which
seems to match the subject of this thread quite nicely:

http://queue.acm.org/detail.cfm?id=1670144
