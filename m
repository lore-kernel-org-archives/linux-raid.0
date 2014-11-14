From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Disks never stop spinning
Date: Fri, 14 Nov 2014 12:11:36 +0800
Message-ID: <546580F8.2040607@fnarfbargle.com>
References: <54610788.6060103@gautschi.net> <21604.47814.651762.246947@tree.ty.sabi.co.uk> <54657187.6020306@gautschi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54657187.6020306@gautschi.net>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Gautschi <patrick@gautschi.net>, Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/11/14 11:05, Patrick Gautschi wrote:
>>    #  hddtemp /dev/sd[bcdef]
>>    /dev/sdb: SAMSUNG HD103UJ: drive is sleeping
>>    /dev/sdc: WDC WD10EZEX-22RKKA0: drive is sleeping
>>    /dev/sdd: ST1000DM003-9YN162: drive is sleeping
>>    /dev/sde: SAMSUNG HD103SJ: drive is sleeping
>>    /dev/sdf: WDC WD10EZEX-22RKKA0: drive is sleeping
>
> Different disks; looks like desktop types.
>
>> That means something else is waking up those disks. To verify
>> this use something like:
>
> FS are not mounted and arrays stopped. There is nothing that wakes them up.
> If a switch them off manually with hdparm -Y they stay off.
>

Are you polling them with smartmontools? I have a unit here where I had 
to add the "standby" :

DEVICESCAN -s (L/../../7/07|S/../../[1-6]/00) -n standby,q -m root -M 
exec /usr/share/smartmontools/smartd-runner

.. clause in smartd.conf. This ensures smartd does not wake the disk 
every 15 minutes for it's poll, and only polls if the drive is already 
spinning.

Failing that, I'd put it to sleep and it'd wake up on the next 15 
minutes smart poll.

Regards,
Brad
