From: Mukund Sivaraman <muks@banu.com>
Subject: Re: RAID-6 recovery questions
Date: Sun, 29 Jan 2012 18:36:18 +0530
Message-ID: <20120129130618.GA4332@misha.banu.com>
References: <20120127081025.GA22388@jurassic>
 <CADNH=7FucU4vxjSom=n=vChHDCAvmZWWagsCgT-WEZE-pyhwKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CADNH=7FucU4vxjSom=n=vChHDCAvmZWWagsCgT-WEZE-pyhwKA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?utf-8?B?QnVyw6lu?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Mathias

On Fri, Jan 27, 2012 at 12:30:36PM +0000, Mathias Bur=C3=A9n wrote:
[snip]
> Hi,
>=20
> (this caters to question 1 & 2)
> I run a 7x 2TB array myself, which has had 2 drive failure the last ~=
2
> years (the age of the array). The first time went smooth, MD kicked
> out the bad drive almost immediately, and when I got the new drive it
> rebuilt happily and everything was fine. The other time (see the last
> few days on this mailing list) the drive wasn't kicked out straight
> away - it kept retrying to read/write those bad sectors, and stalling
> the entire system. I was unable to sync or anything, so I had to pull
> the power, pull the bad disk, then power on the system again and
> perform a RAID6 check (which turned out fine).
>=20
> Lesson learned, you'll want a drive to get kicked out ASAP if it's
> reporting errors. When it's kicked out, you can test it yourself whil=
e
> your RAID6 still chugs along, and if you can fix the errors, stick it
> back into the array. If not, RMA the drive.

Thank you for replying (you're the only one who has replied to these
two questions).  But it doesn't actually answer the question I have.

The problem is that a disk has failed fully, and during rebuild, >1
disks among the remaining members are reporting read errors which were
not known previously -> latent errors (see the figure in the email
which started this topic).  This is not an unlikely situation with
RAID-6 and modern "end-user" SATA disks.

How do we then go about fully or partially recovering data in the
array?


Kind regards,

Mukund
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
