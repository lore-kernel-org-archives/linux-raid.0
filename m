From: Doug Dumitru <doug@easyco.com>
Subject: Re: set sector or minimum write size?
Date: Sun, 28 Aug 2011 17:17:47 -0700
Message-ID: <CAFx4rwQMNctPRQNk74Y=2pLBRAQbKr7gnbkQ97RZ+PWzGZKOag@mail.gmail.com>
References: <CAGtzr3c5+BVB4qB7X2zVh-mRkitHwM+PLJqgadpBbX6S2AnHYw@mail.gmail.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGtzr3c5+BVB4qB7X2zVh-mRkitHwM+PLJqgadpBbX6S2AnHYw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Pearson <kermit4@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

MD does not really work this way.The low level device will advertise a
hardware sector size.=A0 In this case the drive claims it is 512 bytes.
This 512 byte sector size is maintained through the block IO stacks.
Thus MD, volume manager, fdisk, and pretty much everything else gets
512.

It is not possible for MD to enforce a large sector size.=A0 This would
require a new device.=A0 It is possible to create such a new device wit=
h
a kernel module, but it would not really do any good.=A0 Plus a lot of
applications just plain break if they see anything other than 512.

In terms of performance, the drive will take a hit if you give it
non-4K writes.=A0 This hit is pretty bad, if there are a lot of these.
=46ortunately, most applications in Linux are perfectly happy to only
issue 4K aligned requests, if you take some precautions.

1)=A0 Make sure than any partition on the device is 4K aligned.

1a)=A0 The fdisk issue is also important if you are exporting a "block
device".=A0 So if you are using OpenFiler or other SAN applications,
make sure that the client fdisk table is also on 4K centers.=A0 This is
particularly important for volumes used by Windows XP.

2)=A0 If you have the option to set 4K in a filesystem spec, do so.=A0 =
I
know XFS is helped by this.=A0 EXT2,3,4 file systems seem to default to
pretty pure 4K.=A0 Look at the man page for other file systems to see i=
f
there is a "blocksize" option.

Other things like LVM are already 4K (or much larger), so they don't
need anything.

Because Linux has a 4K page cache, most filesystem designs tend to
work on 4K (or multiples thereof) boundaries.=A0 Also, this type of dis=
k
is getting very common, especially for huge (multi-terrabyte) drives.
A lot of SSDs and SANs also work best with 4K.

If you do these things, you might still see an occasional short IO,
but they should be rare.

Doug Dumitru
EasyCo LLC

On Sun, Aug 28, 2011 at 12:43 PM, Chris Pearson <kermit4@gmail.com> wro=
te:
>
> I have a 4k sector size drive claiming to be a 512 sector size drive.
> =A0Is there a way to tell MD to never write less than 4k at a time?
>
> From block dump:
>
> md0_raid1(9007): WRITE block 8 on sdd1 (2 sectors)
>
> happens frequently and probably requires a full revolution of the dis=
k
> unnecessarily.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--
Doug Dumitru
EasyCo LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
