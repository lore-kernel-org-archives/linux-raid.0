From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Home desktop/server RAID upgrade
Date: Wed, 04 Jun 2014 20:29:16 +0800
Message-ID: <538F111C.9070206@fnarfbargle.com>
References: <CAK2H+ef2YNuy9aoipDjYGWJKMi=soW393dKz00iMN8cUuBd+Og@mail.gmail.com>	<20140530212907.0b00e8a3@netstation>	<CAK2H+efDHKGVEdNHUXcDjbHSLKBLDu-DZTTxH9aN2vt+TLHy3A@mail.gmail.com>	<5389B463.5020100@hesbynett.no>	<8mtskybo2j1i4l2bqu51l7ll.1401554092920@email.android.com>	<CAK2H+ecb=HXRKgcguyRF_V0peoN9BPKb81e4rye1+xzONfLe0w@mail.gmail.com>	<538B4173.3030202@hesbynett.no> <CAK2H+ecPFA4yOm+PWoq-jF20KJh1xMKqyRB0WOTdFAVE7t0W1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ecPFA4yOm+PWoq-jF20KJh1xMKqyRB0WOTdFAVE7t0W1A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>, David Brown <david.brown@hesbynett.no>
Cc: Craig Curtin <craigc@prosis.com.au>, "L.M.J" <linuxmasterjedi@free.fr>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/06/14 23:59, Mark Knecht wrote:
>
>     These VMs are the area where my current RAID6 (5 drive, 16k chunk
> size) seems to have been a bad decision. The machine is powered off
> every night. Loading these VMs takes at least 10-15 minutes each
> morning where I see disk activity lights just grinding away the whole
> time. If I had a single _performance_ goal in upgrading the disks it
> would be to improve this significantly. Craig's SSD RAID1 suggestion
> would certainly help here but at 240GB there wouldn't be a lot of room
> left. That may be OK though.
>

Just a data point. I run between 4 & 10 VM's here 24/7 (always 4, 
sometimes 10). I started them out on a 3 drive RAID-5 on 7200RPM disks, 
then migrated them across to a RAID-10 of 15k SAS drives, and from there 
to a 6x240GB RAID-10 of SSD's.

I would _never_ go back to rotating media now. Some of my batch tasks in 
a Windows 7 VM took up to an hour on the disks. I'm down to 20-30 
minutes max now. Granted my workload is pretty atypical.

Much less power, less noise and less heat. Lots to love.

240GB drives are a bit of a price sweet spot, and still were when I 
bought these 6 over a year ago. I just went with 3 from Intel and 3 from 
Samsung just to spread the risk a little bit. 3 are on the MB AHCI 
controller and 3 on an LSI SAS.

Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
