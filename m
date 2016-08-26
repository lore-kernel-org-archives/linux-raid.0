From: Phil Turmel <philip@turmel.org>
Subject: Re: Need Help with crashed RAID5 (that was rebuilding and then had
 SATA error on another drive)
Date: Fri, 26 Aug 2016 08:38:27 -0400
Message-ID: <c26db3f3-a991-006e-833e-b2a79022fbd2@turmel.org>
References: <CADDTLRB9z6J0F6+uO3k-u74qnjZxiagbNLWrg_tP5GSZt-Vd5A@mail.gmail.com>
 <215fd175-65b6-e24b-338f-0c44ae030573@websitemanagers.com.au>
 <CADDTLRBf9NPO6OuF4a3b+xffZgeZRqHRG+pJdPmbc9-Jat0HVQ@mail.gmail.com>
 <d6d3fe0d-3f9f-985f-9bfb-051428cf221b@websitemanagers.com.au>
 <57BBDA5B.3020706@gmail.com> <57BBDC15.5030301@gmail.com>
 <b8c6a380-7e6a-fda9-5834-b85271b26892@websitemanagers.com.au>
 <57BC61F7.8070102@gmail.com>
 <aca4e83f-9a3f-c200-7c16-3b5d9df52c1e@websitemanagers.com.au>
 <57BE450B.4030700@gmail.com>
 <56e86db5-456d-e9c1-339d-ba8903fe5dde@websitemanagers.com.au>
 <57BE52BC.6040908@gmail.com>
 <933228e0-bce4-ffad-f48d-034bf89bc07f@websitemanagers.com.au>
 <57BF9965.1020403@gmail.com>
 <f3d5add5-cfad-e33f-2f75-934189fa501d@turmel.org>
 <57BFAF75.1080807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57BFAF75.1080807@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/25/2016 10:54 PM, Benjammin2068 wrote:
>> You either must have
>> it enabled, or you *must* apply the kernel driver timeout work-around
>> (180 seconds) for that drive.  Failure to do so results in crashed arrays.
> 
> For the ST1000DM003, its SMART capabilities states "SCT Status Supported" -- What does that mean in comparison with the other HD103SJ drives?
> 
> It does SCT but doesn't let the user control it or it doesn't do it at all?

ERC is a feature within the SCT standard.  For modern hard drives,
claiming "SCT" support is comparable to a bottled water supplier
advertising that their product is wet.

> (smartctl -l scterc /dev/sde yields a message that implies control is not supported)

ERC on the other hand is a valuable feature that modern drive
manufacturers make you pay extra for.

>> Enterprise and NAS drives work out of the box.  Desktop/green drives do not.
> 
> Yea - I didn't buy any green drives (purposefully anyway) for this system.

I originally wrote that sentence as "Desktop drives do not."  I added
"/green" to clarify that some non-enterprise, non-NAS drives aren't
marketed as desktop drives, but still lack ERC functionality.

Your ST1000DM003 is marketed as a desktop drive.  Seagate's product page
for this model has links to other models for specialty use cases,
including NAS.

>> Some reading assignments from old discussions (read whole threads if you
>> have time):
>>
>> http://marc.info/?l=linux-raid&m=139050322510249&w=2
>> http://marc.info/?l=linux-raid&m=135863964624202&w=2
>> http://marc.info/?l=linux-raid&m=135811522817345&w=1
>> http://marc.info/?l=linux-raid&m=133761065622164&w=2
>> http://marc.info/?l=linux-raid&m=132477199207506
>> http://marc.info/?l=linux-raid&m=133665797115876&w=2
>> http://marc.info/?l=linux-raid&m=142487508806844&w=3
>> http://marc.info/?l=linux-raid&m=144535576302583&w=2
> 
> Thanks, will go read.

You will find detailed explanations for my comments above in these old
threads.

Phil

