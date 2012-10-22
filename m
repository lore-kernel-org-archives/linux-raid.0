From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: 4x3TB raid5 - no autodetect
Date: Mon, 22 Oct 2012 15:11:11 +0100
Message-ID: <508553FF.6020302@anonymous.org.uk>
References: <441614417.20121022155507@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <441614417.20121022155507@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/10/2012 14:55, Rainer F=FCgenstein wrote:
> I'm trying to create a RAID5 consisting of 4 3TB drives from scratch:
[...]
> - raid created using:
> # mdadm --create /dev/md0 --level=3D5 --metadata=3D1.2 --raid-devices=
=3D4 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> before that the raid was created without "--metadata=3D1.2", also did=
n't
> work.
>
> - on boot, dmesg says:
> md: Autodetecting RAID arrays.
> md: invalid raid superblock magic on sdb1
> md: sdb1 has invalid sb, not importing!
> md: invalid raid superblock magic on sdc1
> md: sdc1 has invalid sb, not importing!
> md: invalid raid superblock magic on sdd1
> md: sdd1 has invalid sb, not importing!
> md: invalid raid superblock magic on sde1
> md: sde1 has invalid sb, not importing!
> md: autorun ...
> md: ... autorun DONE.
[...]
>
> there's something I'm missing here - please advise.

In-kernel auto-assembly is only supported for metadata 0.90, and even=20
then the feature is deprecated. If you have your root filesystem on a m=
d=20
array, use an initrd with mdadm in it to start it.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
