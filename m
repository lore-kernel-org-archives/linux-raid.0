From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: ICH7 sata-ahci + software raid warning
Date: Tue, 11 Jul 2006 08:40:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0607110839330.858@p34.internal.lan>
References: <bb145bd20607100948y2f41e034re3c0fb30c8bd1ad5@mail.gmail.com>
 <Pine.LNX.4.64.0607110823160.858@p34.internal.lan>
 <fd8d0180607110533j7f9fe7c8k7ececea622d7c17b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180607110533j7f9fe7c8k7ececea622d7c17b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 11 Jul 2006, Francois Barre wrote:

> 2006/7/11, Justin Piszcz <jpiszcz@lucidpixels.com>:
>> Why not just --set-faulty or --fail with mdadm?
>> 
>
> If you answer to "Bad blocks maybe, can't test that.", I'll say AFAIK,
> --set-faulty will only stay at the md layer, and won't go through the
> underlying driver (sata here, ata elsewhere, ...), so this will not
> help diagnose the driver behaviour on block read problem.
>
> If you answer to the fact that md does not mark the drive faulty, I
> guess Christian was refering to an automatic to mark the disk faulty,
> not a manual way, in order, for exemple, to trigger a resync with a
> spare drive just after a drive failure has been detected (and not only
> after the admin found it).
>
> As an ugly workaround, a daemon script could look at the current drive
> status regularly (in /sys, in /proc or trying to read /dev/sd?), and
> mark the drive faulty on error...
>

For ICH5 and all other controllers (non-AHCI) of course, I've always seen 
md mark it faulty on a bad disk/sector/etc.

I thought you were just trying to mark it faulty manually for the purpose 
of rebuilding it.

Justin.
