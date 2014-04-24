From: Jeff Wiegley <jeffw@csun.edu>
Subject: Re: Repaired the sectors of a drive, how do I get the md to assemble
 and start degraded?
Date: Thu, 24 Apr 2014 13:24:41 -0700
Message-ID: <53597309.8070506@csun.edu>
References: <53592837.8020406@csun.edu> <alpine.DEB.2.02.1404241923510.19744@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1404241923510.19744@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I don't want to simply re-add the failed drives as I believe
they will start re-syncing won't they? I don't want their data
lost and overwritten. I want the drive to be treated like it
never failed in the first place.

I might have some filesystem corruption but not as much as I
will if the entire drive is resynced.

I also cannot repair the two other dead drives. So I need this
drive treated as is so that array can come up degraded. Then I
can get what data I can off it before replacing all drives
and probably starting fresh.

- Jeff

On 4/24/2014 10:27 AM, Mikael Abrahamsson wrote:
> On Thu, 24 Apr 2014, Jeff Wiegley wrote:
>
>> How do I do this? how do I specify a command to take these 15 drives,
>> mark two of them failed and force the assembly and start of the
>> remaining 13 good drives (though one has probably been marked as failed
>> in the past?)
>
> Try to use --assemble with all working drives (not the failed ones). If it
> doesn't work, add --force. Do not use --create --assume-clean unless you
> really really know what you're doing. If you go down that route, first
> make sure you do mdadm --examine on all devices so you know what the
> superblocks contained before you erase them (which is what --create will
> do).
>
> Did you try to re-add the failed drives initially? If you had been using a
> bitmap, they might have come online and successfully added, and then you
> could have run md repair and avoided data loss altogether.
>

