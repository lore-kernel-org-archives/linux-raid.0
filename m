From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
Date: Sat, 15 Nov 2008 17:00:32 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811151659300.27937@p34.internal.lan>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan> <slrnghu29r.6oa.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrnghu29r.6oa.Mario.Holbe@darkside.dyn.samba-tng.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.orglinux-ide@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 15 Nov 2008, Mario 'BitKoenig' Holbe wrote:

> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> I have enabled debugging in the libata.h file and I find that ata15 is
>> constantly being accessed for some reason, why is this?
> ...
>> Host: scsi14 Channel: 00 Id: 00 Lun: 00
>>    Vendor: _NEC     Model: DVD_RW ND-3520A  Rev: 1.04
>>    Type:   CD-ROM                           ANSI  SCSI revision: 05
>
> Well, if ata15 really is the CD-ROM, hal is likely to poll it :/
>
>
> regards
>   Mario
> -- 
> Evidently men are more intelligent than women. Every woman on earth
> believes that men should be able to read minds. Every man knows this
> is impossible. Ergo, we are more intelligent.

Yes, for this -specific- issue, it was HAL polling the DVD drive multiple 
times a second, this fixed that:

# hal-disable-polling --device /dev/sr0 
Following symlink from /dev/sr0 to /dev/scd0.
Polling for drive /dev/sr0 have been disabled. The fdi file written was
   /etc/hal/fdi/information/media-check-disable-storage_model_DVD_RW_ND_3520A.fdi

#

Justin.
