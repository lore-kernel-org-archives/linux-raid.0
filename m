From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID5 fill up?
Date: Fri, 8 Sep 2006 15:25:17 +0200
Message-ID: <20060908132516.GH19633@percy.comedia.it>
References: <45013873.5040006@cgv.tugraz.at> <450142AC.8010304@tls.msk.ru> <45016177.8080604@cgv.tugraz.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45016177.8080604@cgv.tugraz.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 08, 2006 at 02:26:31PM +0200, Lars Schimmer wrote:
>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA1
>
>Michael Tokarev wrote:
>> Lars Schimmer wrote:
>>> Hi!
>>>
>>> I=B4ve got a software RAiD5 with 6 250GB HDs.
>>> Now I changed one disk after another to a 400GB HD and resynced the
>>> raid5 after each change.
>>> Now the RAID5 has got 6 400GB HDs and still uses only 6*250GB space=
=2E
>>> How can I grow the md0 device to use 6*400GB?
>>=20
>> mdadm --grow is your friend.
>
>Oh, damn, right. I was focussed on --grow to add a new HD to the RAID.=
=2E..
>But isn=B4t there a switch to grow to max possible value?
>Do I always have to search for the biggest value and type it in by han=
d?
man mdadm
=2E...
       -z, --size=3D
=2E...
              This value can be set with --grow for RAID level 1/4/5/6.=
 If the
              array  was created with a size smaller than the currently=
 active
              drives, the extra space can be accessed using --grow.  Th=
e  size
              can  be given as max which means to choose the largest si=
ze that
              fits on all current drives.


--=20
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
