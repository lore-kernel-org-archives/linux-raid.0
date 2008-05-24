From: "NeilBrown" <neilb@suse.de>
Subject: Re: aoe disk not recognized as part of raid
Date: Sat, 24 May 2008 16:26:24 +1000 (EST)
Message-ID: <46141.192.168.1.70.1211610384.squirrel@neil.brown.name>
References: <20080523142525.31d6e06b.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080523142525.31d6e06b.taeuber@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?iso-8859-1?Q?T=C3=A4uber?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 23, 2008 10:25 pm, Lars T=C3=A4uber wrote:
> Hallo!
>
> It seems mdadm doesn't recognises aoe block devices automatically as =
part
> of raid:
>
> monosan:~ # fgrep md9 /etc/mdadm.conf
> ARRAY /dev/md9 level=3Draid1 num-devices=3D2
> UUID=3D23882ab5:8346ffa3:0e2e4f1e:419f2ac9
>
> monosan:~ # cat /proc/partitions
> major minor  #blocks  name
> [...]
>  253    16 1074790400 dm-16
>  253    17 8589934592 dm-17
>  152  2832 1074790400 etherd/e11.1
>
> monosan:~ # mdadm -As
> mdadm: /dev/md9 has been started with 1 drive (out of 2).
>

What does
   mdadm -Asv

show ??

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
