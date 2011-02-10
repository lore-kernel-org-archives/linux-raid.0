From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: raid1 with rotating offsite disks for backup
Date: Thu, 10 Feb 2011 08:43:38 +0000
Message-ID: <4D53A53A.2000409@anonymous.org.uk>
References: <1ADCC31C-C4BD-4D43-829F-9341D3663185@stanford.edu>	<AANLkTik+WR5r_xBAFhKrUCwQgAzz+x2_AVQ9vjr=Rdco@mail.gmail.com> <AANLkTin6UFR6pR-E+z29kTd9VioRVxQqmOR-ABTnWymu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin6UFR6pR-E+z29kTd9VioRVxQqmOR-ABTnWymu@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: hansbkk@gmail.com, Jeff Klingner <klingner@stanford.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/02/2011 19:53, Roberto Spadim wrote:
> i agree with rsync
> rsync is more filesystem related feature
> if you want copy files, you should use rsync
> if you want to copy the device, may be a dd with devices?
> dd if=3D/dev/md0 of=3D/dev/sda
>
> if you want a snapshot copy, you should first remount your filesystem
> to readonly (there=B4s no flock() for /dev/md0 since filesystem don=B4=
t
> use flock() on /dev/md0) or another way to block writes to filesystem
> while you is read from device, some filesystems have online backup
> features..
> i don=B4t know lvm very well, but maybe they implement online backup =
there...
> i don=B4t think it=B4s a problem to solve at md level (it could work,=
 but
> the raid1 purpose is make a fail safe device (or partially safe), not
> a online backup device)

I do both with several of my customers: md array with LVM on top,=20
suspend system services (mailstore), take snapshot, start system=20
services, then rsync diff the snapshot to another drive with luks=20
crypto, which gets rotated off-site once a week. Generally the backup=20
drives are bigger than the system array, so I can keep at least a week'=
s=20
worth of nightlies and several months' worth of weeklies on each one.

Yes, I have my own separate securely-stored copies of their crypto keys=
=2E

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
