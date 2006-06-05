From: Nix <nix@esperi.org.uk>
Subject: Re: Problems with device-mapper on top of RAID-5 and RAID-6
Date: Mon, 05 Jun 2006 21:40:18 +0100
Message-ID: <87verf72vh.fsf@hades.wkstn.nix>
References: <448054DB.1020004@congenio.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <448054DB.1020004@congenio.de> (Uwe Meyer-Gruhl's message of "2 Jun 2006 16:10:51 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: "Dr. Uwe Meyer-Gruhl" <f+gmane@congenio.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2 Jun 2006, Uwe Meyer-Gruhl uttered the following:
> Neil's suggestion indicates that there may be a race condition
> stacking md and dm over each other, but I have not yet tested that
> patch. I once had problems stacking cryptoloop over RAID-6, so it
> might really be a stacking problem. We don't know yet if LVM over RAID
> is affected as well.

I've been running LVM on RAID (spanning two RAID-5 arrays) for some time
now and have had no trouble (that I know of: a check just completed OK,
so the RAID layer at least is consistent). The arrays have both IDE and
SCSI (sym53c875) components.

Of course this is a subtle and intermittent problem so this is hardly
a green light :/

-- 
`Voting for any American political party is fundamentally
 incomprehensible.' --- Vadik
