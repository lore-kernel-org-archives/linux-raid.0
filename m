From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: RAID5 fill up?
Date: Fri, 8 Sep 2006 09:35:14 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0609080931340.23948@filesrv1.baby-dragons.com>
References: <45013873.5040006@cgv.tugraz.at> <450142AC.8010304@tls.msk.ru>
 <45016177.8080604@cgv.tugraz.at> <20060908132516.GH19633@percy.comedia.it>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="566704117-1685796775-1157733314=:23948"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060908132516.GH19633@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--566704117-1685796775-1157733314=:23948
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

 =09Hello Neil & Luca ,

On Fri, 8 Sep 2006, Luca Berra wrote:
> On Fri, Sep 08, 2006 at 02:26:31PM +0200, Lars Schimmer wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>=20
>> Michael Tokarev wrote:
>>> Lars Schimmer wrote:
>>>> Hi!
>>>>=20
>>>> I=B4ve got a software RAiD5 with 6 250GB HDs.
>>>> Now I changed one disk after another to a 400GB HD and resynced the
>>>> raid5 after each change.
>>>> Now the RAID5 has got 6 400GB HDs and still uses only 6*250GB space.
>>>> How can I grow the md0 device to use 6*400GB?
>>>=20
>>> mdadm --grow is your friend.
>>=20
>> Oh, damn, right. I was focussed on --grow to add a new HD to the RAID...=
=2E
>> But isn=B4t there a switch to grow to max possible value?
>> Do I always have to search for the biggest value and type it in by hand?
> man mdadm
> ....
>      -z, --size=3D
> ....
>             This value can be set with --grow for RAID level 1/4/5/6. If =
the
>             array  was created with a size smaller than the currently act=
ive
>             drives, the extra space can be accessed using --grow.  The  s=
ize
>             can  be given as max which means to choose the largest size t=
hat
>             fits on all current drives.

 =09Kuca ,  Thank you for posting this snippet .
 =09Neil ,  Might changing ,

              can  be given as max which means to choose the largest size t=
hat
 =09To
              can  be given as 'max' which means to choose the largest size=
 that

 =09help those reading this be aware that this is a 'string' to add to the
 =09end of --size=3D ?  Also if there are other keywords not quoted ('') th=
is
 =09might be a good opertunity .  ;-)  Tia ,  JimL

--=20
+----------------------------------------------------------------------+
| James   W.   Laferriere |   System    Techniques   | Give me VMS     |
| Network        Engineer | 3600 14th Ave SE #20-103 |  Give me Linux  |
| babydr@baby-dragons.com |  Olympia ,  WA.   98501  |   only  on  AXP |
+----------------------------------------------------------------------+
--566704117-1685796775-1157733314=:23948--
