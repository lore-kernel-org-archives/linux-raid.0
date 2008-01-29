From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 19:57:01 +0300
Message-ID: <479F5ADD.7080907@msgid.tls.msk.ru>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F4CFC.5060305@pobox.com> <20080129163728.GB16250@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080129163728.GB16250@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Moshe Yudkowsky <moshe@pobox.com>, Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> On Tue, Jan 29, 2008 at 09:57:48AM -0600, Moshe Yudkowsky wrote:
>> In my 4 drive system, I'm clearly not getting 1+0's ability to use g=
rub=20
>> out of the RAID10.  I expect it's because I used 1.2 superblocks (wh=
y=20
>> not use the latest, I said, foolishly...) and therefore the RAID10 -=
-=20
>> with even number of drives -- can't be read by grub. If you'd patch =
that=20
>> information into the man pages that'd be very useful indeed.
>=20
> If you have 4 drives, I think the right thing is to use a raid1 with =
4
> drives, for your /boot partition. Then yo can survive that 3 disks
> crash!

By the way, on all our systems I use small (256Mb for small-software sy=
stems,
sometimes 512M, but 1G should be sufficient) partition for a root files=
ystem
(/etc, /bin, /sbin, /lib, and /boot), and put it on a raid1 on all (usu=
ally
identical) drives - be it 4 or 6 or more of them.  Root filesystem does=
 not
change often, or at least it's write speed isn't that important.  But d=
oing
this way, you always have all the tools necessary to repair a damaged s=
ystem
even in case your raid didn't start, or you forgot where your root disk=
 is
etc etc.

But in this setup, /usr, /home, /var and so on should be separate parti=
tions.
Also, placing /dev on a tmpfs helps alot to minimize number of writes
necessary for root fs.

/mjt
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
