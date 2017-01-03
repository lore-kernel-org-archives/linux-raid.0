From: Ben Kamen <benjammin2068@gmail.com>
Subject: Re: Using mdadm --grow to resize a RAID1
Date: Mon, 2 Jan 2017 19:57:46 -0600
Message-ID: <CADDTLRCf1GWUxntGfE=2nL_FKv_Po2Vx0XChti3rcsH4QWzf+A@mail.gmail.com>
References: <4716208e-12a9-1ae8-46f4-a89ae15d9077@gmail.com>
 <586A454F.1010308@youngman.org.uk> <ca87be95-bfb1-10c6-18d4-9aca4a6e3558@gmail.com>
 <20170102212412.19832496@natsu> <e37c42da-71f5-e83e-4e9f-2ec3961a14a0@gmail.com>
 <CADDTLRAY=VHydpXOUMh0OSsVYnYefKyo1vtR3hZx4vyGsSW3tQ@mail.gmail.com>
 <586A993C.8010601@youngman.org.uk> <CADDTLRA2fNyKTCsxK_G-2k4p-01wn16M7T_ruRxt_Dot+6-8Aw@mail.gmail.com>
 <586AA155.9000802@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <586AA155.9000802@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hey all --  just thought I'd report back.

Single User mode was enough to take care of doing the 'mdadm --grow'
and I just did everything else there too (resize2fs).

It was the block size kernel sync (or lack thereof) and then just
being up and running with alll those processes... hahaha.

Thanks everyone for the quick help!

 -Ben
