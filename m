From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: raid5:md3: read error corrected ,  followed by ,  Machine Check
 Exception: .
Date: Sun, 15 Jul 2007 02:04:54 +0100
Message-ID: <20070715020454.19de921f@the-village.bc.nu>
References: <Pine.LNX.4.64.0707141658210.16611@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707141658210.16611@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>, Linux Kernel Maillist <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 14 Jul 2007 17:08:27 -0700 (PDT)
"Mr. James W. Laferriere" <babydr@baby-dragons.com> wrote:

>  	Hello All ,  I was under the impression that a 'machine check' would be 
> caused by some near to the CPU hardware failure ,  Not a bad disk ?

It indicates a hardware failure

> Jul 14 23:00:26 filesrv2 kernel: sd 2:0:1:0: SCSI error: return code = 0x08000002
> Jul 14 23:00:26 filesrv2 kernel: sdd: Current: sense key: Medium Error
> Jul 14 23:00:26 filesrv2 kernel:     Additional sense: Read retries exhausted

So your disk throws a fit

> Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269184 on sdd)
> Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269192 on sdd)

Raid happily recovers the mess

> Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388336 on sdd)
> Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388344 on sdd)
> Jul 14 23:38:48 filesrv2 -- MARK --
> CPU 5: Machine Check Exception: 0000000000000004
> CPU 4: Machine Check Exception: 0000000000000004

And at some point at least 18 minutes after the raid incident you log
CPU problems.

Are you sure the box or the room it is in didn't get excessively hot ?
