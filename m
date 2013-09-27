From: CoolCold <coolthecold@gmail.com>
Subject: Re: Detecting that an array has been stopped
Date: Sat, 28 Sep 2013 03:03:31 +0400
Message-ID: <CAGqmV7o=B6J9S051t36Uj32k+PF4DWVq9Z9D5N2HB2-xrM=SMA@mail.gmail.com>
References: <l1ss60$fun$1@ger.gmane.org>
	<CAGqmV7pYMcupTobbbSW0D-Ykgwu5a4GyVAu8TCC9T9d08FbxOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7pYMcupTobbbSW0D-Ykgwu5a4GyVAu8TCC9T9d08FbxOg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Also, you may be interested in check_raid Nagios plugin - "check_raid
(rev1.119): plugin to check sw/hw RAID status The plugin looks for any
known types of RAID configurations, and checks them all." -
https://apps.ubuntu.com/cat/applications/nagios-plugins-contrib/

On Sat, Sep 28, 2013 at 3:00 AM, CoolCold <coolthecold@gmail.com> wrote:
> Hello!
> I'm a bit confused by what you mean with "swap names" - if you have
> proper mdadm.conf , you will get consistent array names even after
> stop/start cycle . Keeping mdadm.conf within initrd (many distros do
> this by default), will make you happy in case of reboot too.
>
> Hope this info will be useful for you.
>
> On Wed, Sep 25, 2013 at 12:20 AM, Ian Pilcher <arequipeno@gmail.com> wrote:
>> I've successfully gotten my NAS monitoring program to check the status
>> of my RAID arrays by parsing /proc/mdstat.  (Definitely a PITA, but I
>> did get to learn about RAID 10 layouts ans POSIX regular expressions.)
>>
>> I'm now thinking about how to make the program robust in the situation
>> where the array names (in /proc/mdstat) aren't necessarily stable.  For
>> example, a couple of arrays might be stopped for some sort of
>> maintenance activity and "swap" names when they are reassembled.
>>
>> The obvious answer is to use mdadm to check the UUIDs of the arrays, but
>> I don't want to do that every time I check the RAID status (currently
>> every 30 seconds).  So my plan is to only read the UUID of an array
>> when it first appears in /proc/mdstat (i.e. it wasn't there the last
>> time I read the file).
>>
>> This will work as long as the program notices that an array has been
>> stopped before a (possibly different) array appears with the same name.
>> So it would be nice if there were a simple way to reliably detect that
>> a particular array has been stopped -- even if a different array has
>> since been started with the same name.  It appears that I can do this
>> pretty easily with sysfs.
>>
>> From my initial testing, it looks like I can open each array's
>> array_state file when I first detect the array, and lseek/read will
>> return ENODEV if the array is ever stopped -- even if the array is
>> restarted (with the same or a different name) or if a different array is
>> started with the same name.
>>
>> It seems almost too easy.
>>
>> Is there any reason that this approach won't work?
>>
>> Thanks!
>>
>> --
>> ========================================================================
>> Ian Pilcher                                         arequipeno@gmail.com
>> Sometimes there's nothing left to do but crash and burn...or die trying.
>> ========================================================================
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Best regards,
> [COOLCOLD-RIPN]



-- 
Best regards,
[COOLCOLD-RIPN]
