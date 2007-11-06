From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Tue, 6 Nov 2007 06:29:11 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711060628450.3010@p34.internal.lan>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
 <18222.16003.92062.970530@notabene.brown>  <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>
  <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>
 <Pine.LNX.4.64.0711051335450.11422@p34.internal.lan>
 <e9c3a7c20711051619u7054aab9l208b604b9e58fb61@mail.gmail.com>
 <47303FB8.7000801@systella.fr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-963662122-1194348551=:3010"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47303FB8.7000801@systella.fr>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Cc: Dan Williams <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-963662122-1194348551=:3010
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 6 Nov 2007, BERTRAND Jo=EBl wrote:

> =09Done. Here is obtained ouput :
>
> [ 1265.899068] check 4: state 0x6 toread 0000000000000000 read=20
> 0000000000000000 write fffff800fdd4e360 written 0000000000000000
> [ 1265.941328] check 3: state 0x1 toread 0000000000000000 read=20
> 0000000000000000 write 0000000000000000 written 0000000000000000
> [ 1265.972129] check 2: state 0x1 toread 0000000000000000 read=20
> 0000000000000000 write 0000000000000000 written 0000000000000000
>
>
> =09For information, after crash, I have :
>
> Root poulenc:[/sys/block] > cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4]
> md_d0 : active raid5 sdc1[0] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1]
>      1464725760 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]
>
> =09Regards,
>
> =09JKB

After the crash it is not 'resyncing' ?

Justin.

---1463747160-963662122-1194348551=:3010--
