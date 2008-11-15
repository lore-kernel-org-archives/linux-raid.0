From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
Date: Sat, 15 Nov 2008 18:39:04 +0100
Message-ID: <slrnghu29r.6oa.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755368AbYKORj3@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> I have enabled debugging in the libata.h file and I find that ata15 is 
> constantly being accessed for some reason, why is this?
...
> Host: scsi14 Channel: 00 Id: 00 Lun: 00
>    Vendor: _NEC     Model: DVD_RW ND-3520A  Rev: 1.04
>    Type:   CD-ROM                           ANSI  SCSI revision: 05

Well, if ata15 really is the CD-ROM, hal is likely to poll it :/


regards
   Mario
-- 
Evidently men are more intelligent than women. Every woman on earth
believes that men should be able to read minds. Every man knows this
is impossible. Ergo, we are more intelligent.
