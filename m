From: "berk walker" <berk@panix.com>
Subject: Re: Broken harddisk
Date: Sat, 29 Jan 2005 18:30:42 -0500
Message-ID: <opsld0xgoiv40d6c@berk.site>
References: <200501291617.j0TGHG918839@www.watkins-home.com> <41FBD68C.4040701@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41FBD68C.4040701@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>, Guy <bugzilla@watkins-home.com>
Cc: 'Gordon Henderson' <gordon@drogon.net>, "'T. Ermlich'" <pelegrine@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think it might be a good idea to check memory, and power supply.  I have  
had several motherboards where the IDE channels went bad. I have become a  
believer of not using exact same drives in an array, because today's  
quality control in manufacturing (not design nor testing) Clones may have  
very similardegradation rates, suddenly, it seems, dying together.  it is  
not possible to get the manufacturer's name and lot for the platters, but  
_maybe_ buying similar drives of different mfgs might cut down the  
multiple failure rates.  raid1 your boot disk.  another compubox sometimes  
helps as a control for checking hdwe.  Think about spending the extra bux  
for another raid box, and have them rsync'd. you _can_ have stable,  
automatic, online backup of all of your data (don't forget the ups's), if  
the house burns down, it will be trivial that you lost data - or you could  
share mirroring with a remotely located friend, so if one house burnt to  
the ground, maybe the other still has the data.  doing the continuous  
circle of backups level 1 thru 9 by hand feeding tapes just sux, and might  
not even work on restore.  knew a business that backed up every day,  
system fried - and the tapes could not be read.

sorry - too much from me (just thinking that it's too damned bad that we  
can't go to the local whatever store and walk out with SCSI stuff.

b-


On Sat, 29 Jan 2005 10:31:40 -0800, Mike Hardy <mhardy@h3c.com> wrote:

>
> Guy wrote:
>> For future reference:
>>  Everyone should do a nightly disk test to prevent bad blocks from  
>> hiding
>> undetected.  smartd, badblocks or dd can be used.  Example:
>> dd if=/dev/sda of=/dev/null bs=64k
>>  Just create a nice little script that emails you the output.  Put this
>> script in a nighty cron to run while the system is idle.
>
> While I agree with your purpose 100% Guy, I respectfully disagree with  
> the method. If at all possible, you should use tools that access the  
> SMART capabilities of the device so that you get more than a read test -  
> you also get statistics on the various other health parameters the drive  
> checks some of which can serve fair warning of impending death before  
> you get bad blocks.
>
> http://smartmontools.sf.net is the source for fresh packages there, and  
> smartd can be set up with a config file to do tests on any schedule you  
> like, emailing you urgent results as it gets them, or just putting  
> information of general interest in the logs that Logwatch picks up.
>
> If you're drives don't talk SMART (older ones don't, it doesn't work  
> through all interfaces either) then by all means take Guy's advice. A  
> 'dd' test is certainly valuable. But if they do talk SMART, I think its  
> better
>
> -Mike
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Using Opera's revolutionary e-mail client: http://www.opera.com/m2/
