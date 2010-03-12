From: Asdo <asdo@shiftmail.org>
Subject: Re: possible bus loading problem during resync
Date: Fri, 12 Mar 2010 12:00:32 +0100
Message-ID: <4B9A1ED0.7060902@shiftmail.org>
References: <4B95EB5E.5090702@vorgon.com>
 <73e903671003090230y135d104cte15e07604b85b8aa@mail.gmail.com>
 <4B962A41.50207@shiftmail.org> <871vfrcsk1.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <871vfrcsk1.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Kristleifur Daoason <kristleifur@gmail.com>, "Timothy D. Lenz" <tlenz@vorgon.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


>> If that is true, how does that happen, the driver is hung? But anyway,
>> how can such things happen when there is more than one CPU-core?
>>     
>
> A drive produces an error, the whole controler hangs and resets all
> ports, all drives have to finish being reset before any IO can continue.
> Hapens easily enough.
>   
Ok but this is a multi-core CPU and he said Putty and WinSCP were hung.
Ok for WinSCP... but Putty?

Timothy is Putty hung on array check even on NCQ disabled?

What is the resync speed? If it is very high it could be a CPU 
starvation but it's strange with only 2 drives. If it is very low I am 
not sure.
Are disks write caches enabled?

I am not able to spot any problem from your iostat or dmesg.
Note: yes the iostat -x 1 was supposed to be captured during resync.
Trigger a resync manually for the test. You can start it with echo check 
and stop it with echo idle > /sys/block/mdX/md/sync_action


