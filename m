From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID performance
Date: Fri, 15 Feb 2013 16:01:38 -0700
Message-ID: <947F4E8D-89CC-485E-8B26-653BCDFEB584@colorremedies.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <51157141.90205@hardwarefreak.com> <9ABA2459-DB04-40CA-996E-D02FEE43291B@colorremedies.com> <511D8AEF.8040202@websitemanagers.com.au> <80A5C958-6E76-49BD-9CDC-3E8705B401C5@colorremedies.com> <511DB326.1090406@websitemanagers.com.au> <C0297DA6-F16C-4527-A129-050C3BD6121D@colorremedies.com> <511E17BF.5030301@websitemanagers.com.au>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511E17BF.5030301@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: "linux-raid@vger.kernel.org list" <linux-raid@vger.kernel.org>, "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>
List-Id: linux-raid.ids


On Feb 15, 2013, at 4:10 AM, Adam Goryachev <mailinglists@websitemanage=
rs.com.au> wrote:
>=20
> Warning: Partition 1 does not end on cylinder boundary.
>=20
> I'm not sure why I get that warning, or if it should worry me... I
> suppose I can always extend it a bit bigger if there is any problem w=
ith
> this?

Because that fdisk is old and it's still thinking in the era of cylinde=
r head sector; but that doesn't matter anymore. Everything is access by=
 LBA these days.


> it is topping out at 213M/sec=85

=46or reference, I have a 2011 Macbook Pro (Core i7 2820QM) with SATA R=
ev 3.0, and a Samsung 830 SSD (the baby brother to the 840 Pros you hav=
e) and I consistently get 463 MB/s reads and 417 MB/s writes (with Bonn=
ie++). That's one SSD, not RAID or anything. And it's a laptop.

> Just a reminder, these are the Intel 320 series 480G SSD's.

Hmm, I guess I'm confused.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
