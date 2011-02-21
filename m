From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 13:24:20 -0500
Message-ID: <4D62ADD4.8080601@cfl.rr.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com> <4D517F4F.4060003@gmail.com> <4D5245DF.4020401@hardwarefreak.com> <iiu4rc$9ju$1@dough.gmane.org> <AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com> <AANLkTik6D-r1ZbgxEACHZK9760pcUBB+3e7wVX3oqrKP@mail.gmail.com> <20110209161916.GB8632@bounceswoosh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110209161916.GB8632@bounceswoosh.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Eric D. Mudama" <edmudama@bounceswoosh.org>
Cc: "Scott E. Armitage" <launchpad@scott.armitage.name>, Roberto Spadim <roberto@spadim.com.br>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/9/2011 11:19 AM, Eric D. Mudama wrote:
> For SATA devices, ATA8-ACS2 addresses this through Deterministic Read
> After Trim in the DATA SET MANAGEMENT command.  Devices can be
> indeterminate, determinate with a non-zero pattern (often all-ones) or
> determinate all-zero for sectors read after being trimmed.

IIRC, it was a word in the IDENTIFY response, not the DATA SET
MANAGEMENT command.

On 2/9/2011 11:28 AM, Scott E. Armitage wrote:
> Who sends this command? If md can assume that determinate mode is
> always set, then RAID 1 at least would remain consistent. For RAID 5,
> consistency of the parity information depends on the determinate
> pattern used and the number of disks. If you used determinate
> all-zero, then parity information would always be consistent, but this
> is probably not preferable since every TRIM command would incur an
> extra write for each bit in each page of the block.

The drive tells YOU how its trim behaves; you don't command it.

If the drive is deterministic and always returns zeros after TRIM, then
mdadm could pass the TRIM down and process it like a write of all zeros,
and recompute the parity.  If it isn't deterministic, then I don't think
there's anything you can do to handle TRIM requests.
