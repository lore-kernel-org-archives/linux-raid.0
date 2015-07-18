From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Reversing parity recalculation on out-of-order RAID 6 array
Date: Sat, 18 Jul 2015 07:33:08 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1507180731040.11810@uplift.swm.pp.se>
References: <CAFcup8FgJqu6q2BoUc7OSEL=iCFf_43wzj7dBuFXYp2R0t2kdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFcup8FgJqu6q2BoUc7OSEL=iCFf_43wzj7dBuFXYp2R0t2kdg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Reddie <steven.reddie@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 18 Jul 2015, Steven Reddie wrote:

> I'm kind of hoping that all of this might have already been done, so
> any pointers would be appreciated.

https://raid.wiki.kernel.org/index.php/RAID_Recovery
https://raid.wiki.kernel.org/index.php/Permute_array.pl

There have historically been lots of threads here with people having the 
same problems, so if you search the archives for things like 
"assume-clean", "order", "mdadm", "create", "superblock", you'll find 
multiple examples of people actually successfully getting out of the 
problem you're also having.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
