From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Booting from a raid1 device ?
Date: Tue, 28 Oct 2003 11:56:44 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031028105644.GF30725@marowsky-bree.de>
References: <20031027152554.7738.qmail@web14507.mail.yahoo.com> <3F9D412A.F68B1461@SteelEye.com> <200310272311.19232.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200310272311.19232.dusty@strike.wu-wien.ac.at>
To: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>, Paul Clements <Paul.Clements@SteelEye.com>, donj@asaca.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-10-27T23:11:19,
   Hermann Himmelbauer <dusty@strike.wu-wien.ac.at> said:

> BTW, assuming I have md.o not as module but statically in the kernel,=
 which=20
> bootloader would support RAID1? I heard LlLO does this job but does a=
lso grub=20
> - which I prefer - support Linux SW-RAID1?

grub doesn't yet afaik.

> What about RAID5? Is there any bootloader that supports it?

No.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering	      \ ever tried. ever failed. no matt=
er.
SUSE Labs			      | try again. fail again. fail better.
Research & Development, SUSE LINUX AG \ 	-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
