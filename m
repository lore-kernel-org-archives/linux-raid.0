From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Re: md failing mechanism
Date: Sat, 23 Jan 2016 13:33:39 +0300
Message-ID: <56A35703.2020702@yandex.ru>
References: <56A26E11.2090703@yandex.ru> <56A28309.9080806@turmel.org> <56A2A2C3.9000801@yandex.ru> <CACsGCyTUBRrQgt0GiVp1R6pv-4gO44Ro7pgm4iCq+1KwWDoPsg@mail.gmail.com> <56A2B639.7000902@yandex.ru> <56A2CA93.8020806@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A2CA93.8020806@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Edward Kuns <eddie.kuns@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> I wonder what happens if the only drive in a degraded mirror fails?..
>
> Or any drive in a raid5 hits an error while replacing a failed disk.
>
> BOOM.

Oh... That sucks. I understand that BOOM would happen on a RAID-F, but 
kicking the last drive doesn't seem like a very rational thing to do - 
you would get a RAID with zero drives, which is not something anybody 
would want in any situation!.. I thought it would get into some kind of 
extreme panic mode so that you could at least save what you can...

Actually, it would make sense to avoid "BOOM" as much as possible; 
instead of going into a "BOOM" mode, it should go into some kind of 
"recovery" mode, when the array immediately turns read-only and allows 
you to salvage as much data as you can from the faulty drive. It would 
be especially useful in RAID5; only one faulty sector or even some other 
stupid error without even faulty sectors should not cause total data 
loss!.. I don't think it would be very hard to implement, or contradict 
some important philosophy, but it would save data, jobs and lives. :)

Well, suppose "BOOM" happened on my RAID1, and both drives failed. 
Naturally, not at the same time, so data differs between the drives. So 
I have two faulty drives; is it possible (with some other recovery 
software?) to just mount each one read-only and copy data from it?.. I 
can live with having to copy as much data as I can from the first one 
and try to copy the rest from the older drive. I mean, I basically have 
the entire filesystem there! I should be able to just mount the 
filesystem on that drive, skipping the RAID header - just fdisk the 
drive, delete the RAID partition and create another one starting a few 
blocks later!.. Would that not work?.. That's actually why I chose 
RAID1; even if everything goes BOOM, I should be able to mount the 
drives separately!..


-- 
darkpenguin
