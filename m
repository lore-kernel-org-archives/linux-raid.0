From: Dominique <dcouot@hotmail.com>
Subject: Re: 4HDD Raid5 - 2 Disk fails
Date: Mon, 15 Oct 2012 12:53:45 +0200
Message-ID: <BLU0-SMTP391CD3AE0B62A72243FD435C9710@phx.gbl>
References: <BLU0-SMTP21143DB89A7F6581069200BC9840@phx.gbl> <506D5D0B.2000203@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <506D5D0B.2000203@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

Thanks everyone for the input. Sorry for the delayed followup. The NAS 
is about 1600 km away, so I'll have to wait to get access to it to 
extract the discs. In the meantime, I powered it off.

Dominique

On 04/10/2012 11:55, Adam Goryachev wrote:
> On 04/10/12 19:33, Dominique wrote:
>> Hi,
>>
>> I am writing here out of desperation, and lost hope. I have a NAS with
>> a 4 HDD Raid 5 setup. A week ago, we suffered a power outage that
>> seemed to have fried 2 of the 4 disks at the same time. I say seemed,
>> since I have some contradictory information: 3 of the 4 power leds are
>> still active, the web interface shows only 2 of 4 disks, and cli
>> information shows that disk sda is partially answering, sbd and sdc
>> are ok, sdd seems to be totally dead.
>>
>> Don't ask about the backup.
>>
>> Is there anything I can do to get sda back to some life to save what
>> can be saved ?
> My limited suggestions:
> 1) Since this is the state of the drive after a power cycle, probably
> another power cycle won't be any worse...
> Remove the drive, and connect to a standard linux machine, also connect
> a brand new identical (size) drive
> Use dd_rescue to attempt to copy as much as possible from the dead drive
> to the new drive
> Add the new drive back to the NAS, and use some CLI magic to re-create
> the raid array pretending that it is all clean
> Do a backup
>
> You should try the dd_rescue ASAP, this could easily take a few days
> depending on the amount of damage, and the size of the drive. If this
> fails, then forget about the rest of the steps.... and start looking for
> backups, or perhaps attempt a professional data recovery agency (very
> expensive).
>
> For how to do the dd_rescue, ask google, there are very good information
> on this already, just ensure to use the gnu dd_rescue.
>
> Regards,
> Adam
>
