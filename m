From: Chris Murphy <lists@colorremedies.com>
Subject: Re: moving spares into group and checking spares
Date: Wed, 14 Sep 2016 16:33:59 -0600
Message-ID: <CAJCQCtQJwOTYsWubd0rV-6PRL4kmVRKLfLr3=7ZPr1Zb3SrwtQ@mail.gmail.com>
References: <nramjg$n07$1@blaine.gmane.org> <20160914092959.GA3584@metamorpher.de>
 <nrc2pm$2a9$1@blaine.gmane.org> <20160914232249.6e5fc568@natsu> <nrce27$2km$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <nrce27$2km$1@blaine.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: scar <scar@drigon.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 14, 2016 at 3:05 PM, scar <scar@drigon.com> wrote:
> Roman Mamedov wrote on 09/14/2016 11:22 AM:
>>
>> But you think an 11-member RAID5, let alone four of them joined by LVM is
>> safe? From a resiliency standpoint that setup is like insanity squared.
>
>
> yeah it seems fine?  disks are healthy and regularly checked, just wondering
> how to check the spares.  use cron to schedule weekly smartctl long test?

That you're asking that question now makes me wonder if you've made
certain SCT ERC value is less than SCSI command timer value? If that's
not true, I give you 1 in 3 chances of complete array collapse
following a single drive failure if they are big drives, and 1 in 4
odds if they're just 2T or less. So you need to make certain, because
it's not the default configuration unless you have NAS or enterprise
drives across the board with properly preconfigured SCT ERC out of the
box.



-- 
Chris Murphy
