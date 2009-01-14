From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: trouble adding spare
Date: Wed, 14 Jan 2009 10:14:30 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901141012050.19747@p34.internal.lan>
References: <496DB3A4.4090605@fastmail.co.uk> <alpine.DEB.1.10.0901140654100.11696@p34.internal.lan> <496DE2BD.6070905@fastmail.co.uk> <496DE763.9010300@fastmail.co.uk> <alpine.DEB.1.10.0901140830280.11696@p34.internal.lan> <496DF771.4010407@fastmail.co.uk>
 <496DFFF0.2060807@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496DFFF0.2060807@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Wed, 14 Jan 2009, Max Waterman wrote:

> Max Waterman wrote:
>>> 
>>> If that does not work, clean the drive out manually after removing it as a 
>>> spare from the array:
>>> dd if=/dev/zero of=/dev/sdi bs=1M
>> This is taking forever
> I stopped it after about half an hour, hoping that it had made garbage of 
> whatever was the problem.
>
> I then added it into the array and it worked as before.
>
> However, it still wasn't added when I rebooted.
>
> ...but, there is something different. Now, when I --examine /dev/sdi, it 
> gives output for the whole array including 2 spares, which is the end result 
> I expect :
>
> Active Devices : 6
> Working Devices : 8
> Failed Devices : 0
> Spare Devices : 2
>
> However, --detail /dev/md2 still denies /dev/sdi exists :
>
> Active Devices : 6
> Working Devices : 7
> Failed Devices : 0
> Spare Devices : 1
>
> What's up?
>
> Max.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

The superblock is at the end of the disk for 0.90.00 superblocks, so you 
would need to write to end of the disk or just let dd clear out the entire 
disk.  Honestly though that may not fix the root cause of the problem, we 
may need to wait for others on the list and/or Neil to check this one out. 
It seems very strange, can you post the regular output that people ask 
for so once they see your mail, they will have (hopefully) most of what 
they need to diagnose the problem.

1. mdadm -D /dev/mdX
2. cat /proc/mdstat
3. mdadm -Esvvv
4. uname -a

Justin.
