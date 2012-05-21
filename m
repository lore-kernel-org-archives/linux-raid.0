From: Brian Candler <B.Candler@pobox.com>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Mon, 21 May 2012 15:19:25 +0100
Message-ID: <20120521141925.GA9011@nsrc.org>
References: <4FAAE8F1.8000600@pocock.com.au>
 <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
 <4FABC7C6.4030107@turmel.org>
 <CALFpzo6BECrv2eTbSRKwUzpTopx_0EmD+UipqUf-XE=vzz2OnQ@mail.gmail.com>
 <4FABE724.40103@turmel.org> <4FAC0C05.1090007@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FAC0C05.1090007@pocock.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Cc: Phil Turmel <philip@turmel.org>, Marcus Sorensen <shadowsor@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 10, 2012 at 06:42:13PM +0000, Daniel Pocock wrote:
> Ok, so I bought an enterprise grade drive, the WD RE4 (2TB) and I'm
> about to add it in place of the drive that failed.
> 
> I did a quick check with smartctl:
> 
> # smartctl -a /dev/sdb -l scterc
> ....
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)
> 
> so the TLER feature appears to be there.  I haven't tried changing it.
> 
> For my old Barracuda 7200.12 that is still working, I see this:
> 
> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled
> 
> and a diff between the full output for both drives reveals the following:
> 
> -SCT capabilities:             (0x103f) SCT Status supported.
> +SCT capabilities:             (0x303f) SCT Status supported.
>                                         SCT Error Recovery Control
> supported.
>                                         SCT Feature Control supported.
>                                         SCT Data Table supported.

But FYI, the new Seagate Barracuda 3TB ST3000DM001 drives I have here do
*not* support this feature.  Has Seagate started crippling its
consumer-grade drives?

    root@storage3:~# smartctl -l scterc /dev/sdb 
    smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.3.4-030304-generic] (local build)
    Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

    Warning: device does not support SCT Error Recovery Control command

    root@storage3:~# smartctl -l scterc,70,70 /dev/sdb 
    smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.3.4-030304-generic] (local build)
    Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

    Warning: device does not support SCT Error Recovery Control command

    root@storage3:~# smartctl -i /dev/sdb -q noserial
    smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.3.4-030304-generic] (local build)
    Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

    === START OF INFORMATION SECTION ===
    Device Model:     ST3000DM001-9YN166
    Firmware Version: CC4C
    User Capacity:    3,000,592,982,016 bytes [3.00 TB]
    Sector Sizes:     512 bytes logical, 4096 bytes physical
    Device is:        Not in smartctl database [for details use: -P showall]
    ATA Version is:   8
    ATA Standard is:  ATA-8-ACS revision 4
    Local Time is:    Mon May 21 15:16:53 2012 BST
    SMART support is: Available - device has SMART capability.
    SMART support is: Enabled

The Hitachi Deskstar HDS5C3030ALA630 *does* support scterc.

Regards,

Brian.
