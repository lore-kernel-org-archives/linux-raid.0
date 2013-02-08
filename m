From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID performance
Date: Thu, 7 Feb 2013 17:02:46 -0700
Message-ID: <37E3C429-0A78-4DAE-BD2C-F23CF931BD91@colorremedies.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <5113A3D4.6000605@turmel.org> <5113A4E9.5020005@websitemanagers.com.au> <5113A628.6010304@turmel.org> <9DD5BA53-A9DF-4D8C-AE5C-BD6D69FAEF2C@colorremedies.com> <C96434C1-FD46-456E-9FE2-C0B50727D219@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C96434C1-FD46-456E-9FE2-C0B50727D219@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Feb 7, 2013, at 4:48 PM, Chris Murphy <lists@colorremedies.com> wrot=
e:
>=20
> ***On Feb 7, 2013, at 6:08 AM, Adam Goryachev <mailinglists@websitema=
nagers.com.au> wrote:
>=20
>> Basically, on occasion, when a user copies a
>> large file from disk to disk,

> Why did you reject NFS =85

A sign of brain deficiency, responding to myself=85

Maybe this is an array to array transfer (?) and not LV to LV transfer =
where both LVs are on this SSD array? If it's the latter, geez, use NFS=
=2E This transaction is reduced to a rename (i.e. a move). Super fast.=20

Even if it's the former, with different block devices on the same serve=
r, I'm pretty sure NFSv4 can reduce this to a cp between devices, rathe=
r than piping the data all the way to the client, just to have the clie=
nt pipe it back to the server. Although I'm sure someone will correct m=
e if I'm wrong.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
