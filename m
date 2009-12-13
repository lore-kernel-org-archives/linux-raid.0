From: =?ISO-8859-2?Q?Micha=B3_Przy=B3uski?= <mikylie@gmail.com>
Subject: Re: Configurazione RAID SOFTWARE su vecchio PC: CONSIGLI
Date: Sun, 13 Dec 2009 21:53:00 +0100
Message-ID: <6c4602af0912131253p1acd5843r46af6c086ee97bb5@mail.gmail.com>
References: <26769455.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <26769455.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: mig81 <fluxus@sonicurbs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ciao mig81,

2009/12/13 mig81 <fluxus@sonicurbs.com>:
>
> Ciao a tutti
> ...

I stronly suggest using English, that way you could get more replies.

Now, from what I understood (mostly through google translate).

I recall that AHA-2940U has just 1 SCSI channel. So it doesn't matter
if both disks are inside, or one is in, and the other is out. That
means you can totally stay with your current, all internal, setup.

As for the 2nd question, I don't quite understand it (my Italian is
totally rusty), but if you want to use the IDE harddisk as boot drive,
and just store some data on that 2*SCSI software raid, I recommend
putting bootloader on the IDE drive.

However, be warned, that RH 7.0 does not use the md driver which is
this list about. It's using the old "raidtools" package (or at least I
suppose so, since my RH 7.2 has
raidtools-0.90 installed).

Saluti,
Mike
