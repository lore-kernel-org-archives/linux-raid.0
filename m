From: Luca Berra <bluca@comedia.it>
Subject: Re: Array over arrays - how to autoassemble correctly?
Date: Wed, 27 Jan 2010 20:41:39 +0100
Message-ID: <20100127194139.GA18250@maude.comedia.it>
References: <73e903671001271032q1802c678i860744c72e2a92f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <73e903671001271032q1802c678i860744c72e2a92f3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jan 27, 2010 at 06:32:57PM +0000, Kristleifur Da=F0ason wrote:
># mdadm.conf
>#
>
># by default, scan all partitions (/proc/partitions) for MD superblock=
s.
># alternatively, specify devices to scan, using wildcards if desired.
>DEVICE partitions /dev/md/d0 /dev/md/d1
>
># auto-create devices with Debian standard permissions
># CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dmdp
>
># automatically tag new arrays as belonging to the local system
>HOMEHOST <system>
>
># definitions of existing MD arrays
>
>ARRAY /dev/md/d0 metadata=3D1.1 name=3Dmamma:d0 UUID=3D7f98e926:206a8e=
be:59fc8d7b:4644a883 level=3Draid6 num-devices=3D6 # container=3D6f98a7=
a8:d7b50181:587c27d1:59d6d137
>
>ARRAY /dev/md/d1 metadata=3D1.1 name=3Dmamma:d1 UUID=3Dda547022:042a6f=
68:d5fe251e:5e89f263 level=3Draid6 num-devices=3D6 # container=3D6f98a7=
a8:d7b50181:587c27d1:59d6d137
>
>ARRAY /dev/md/tank metadata=3D1.1 name=3Dmamma:tank UUID=3D6f98a7a8:d7=
b50181:587c27d1:59d6d137 level=3Draid0 num-devices=3D2 devices=3D/dev/m=
d/d0,/dev/md/d1
>

this kind of setup should be working without any issue on recent mdadm
try removing
DEVICE partitions /dev/md/d0 /dev/md/d1
and the "devices=3D/dev/md/d0,/dev/md/d1" from mdadm.conf
and let it discover things on boot by itself

L.


--=20
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
