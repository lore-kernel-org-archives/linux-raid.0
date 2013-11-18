From: Martin Wilck <mwilck@arcor.de>
Subject: Re: MDADM 3.3 broken?
Date: Mon, 18 Nov 2013 21:22:57 +0100
Message-ID: <528A7721.8080604@arcor.de>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/18/2013 07:26 PM, David F. wrote:
> Hi,
> 
> we updated our linux disk with mdadm 3.3 from 3.2.6 and customers are
> finding their RAID is no longer detected.  It's only been a couple
> weeks and based on the number of customers, we know there is an issue.
>  We're having those with problems workaround by having them load
> dmraid instead for now.
> 
> We also did tests locally and finding intermittent problems with
> RAID-0 on ISW - sometimes 3.3 doesn't identify both drives as RAID
> members.  3.2.6 works 100% of the time.
> 
> Also with DDF RAID - cisco server for example not detecting RAID5 -
> C220M3_LFF_SpecSheet.pdf. I believe they are using the LSI MegaRaid
> since DMRAID reports that.

Could you please provide mdadm -E and possibly mdadm --dump output of
the disks that aren't detected? How does RAID discovery work on your
systems? Are you using standard udev rules or something special? How
does your mdadm.conf look like?

Regards
Martin


> 
> Are these problems known - we wouldn't mind moving to the latest
> version if your pretty sure it fixes it, otherwise we're going to have
> to revert to 3.2.6?
> 
> TIA!!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

