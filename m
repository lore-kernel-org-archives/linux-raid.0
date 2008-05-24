From: "NeilBrown" <neilb@suse.de>
Subject: Re: aoe disk not recognized as part of raid
Date: Sat, 24 May 2008 16:27:45 +1000 (EST)
Message-ID: <46144.192.168.1.70.1211610465.squirrel@neil.brown.name>
References: <20080523142525.31d6e06b.taeuber@bbaw.de>
    <20080523170056.d6e39787.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080523170056.d6e39787.taeuber@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?iso-8859-1?Q?T=C3=A4uber?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 24, 2008 1:00 am, Lars T=C3=A4uber wrote:
> Sorry!
>
>> mdadm version 2.6.6 although it is reported as:
>> monosan:~ # mdadm -V
>> mdadm - v2.6 - 21 December 2006
>
> I accidentally compiled mdadm 2.6 instead of 2.6.6. But this is even
> worse:
>
> monosan:~ # mdadm -V
> mdadm - v2.6.6 - 19th May 2008
> monosan:~ # mdadm -As
> Segmentation fault

That's bad.
What do you get from:

 ulimit -c unlimited
 mdadm -As
 gdb `which mdadm` core
 where

??

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
