From: "David Lethe" <david@santools.com>
Subject: Re: Software RAID1 deadlock in 2.6.25 kernels
Date: Tue, 1 Jul 2008 15:21:00 -0500
Message-ID: <108e01c8dbb8$0ae69674$e90df40a@exchange.rackspace.com>
Reply-To: <David@santools.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>, michael@kmaclub.com
Cc: Richard Scobie <richard@sauce.co.nz>, Mike McCarthy <mike@w1nr.net>, Bill Davidsen <davidsen@tmr.com>, Michael Bussmann <bus@mb-net.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sounds like you worked for microsoft ... "i have 3 systems running XP and I never had a blue screen of death, so there is nothing wrong with the OS"  :)

david

-----Original Message-----

From:  "David Rees" <drees76@gmail.com>
Subj:  Re: Software RAID1 deadlock in 2.6.25 kernels
Date:  Tue Jul 1, 2008 2:03 pm
Size:  1K
To:  "michael@kmaclub.com" <michael@kmaclub.com>
cc:  "Richard Scobie" <richard@sauce.co.nz>; "Mike McCarthy" <mike@w1nr.net>; "Bill Davidsen" <davidsen@tmr.com>; "Michael Bussmann" <bus@mb-net.net>; "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

On Mon, Jun 30, 2008 at 1:19 PM, michael@kmaclub.com 
<michael@kmaclub.com> wrote: 
> Richard Scobie wrote: 
>> Mike McCarthy wrote: 
>>> Bill Davidsen wrote: 
>>>> Wonder if hardware or software is happening, sounds like an mishandled 
>>>> hardware error, but I'm guessing. I have a server with RAID1 and Fedora 
>>>> 2.6.22.14-72.fc6PAE kernel, up 72 days, no problems. 
>>> 
>>> 2.6.22 is running fine.  The problems are in the 2.6.25 kernel (FC9 and 
>>> SUSE 11.0) 
>> 
>> FC9 running on RAID 1 (ata_piix) for the last 3 weeks or so, with no 
>> trouble. 
> 
> Same here.  I haven't had any issues with RAID 1 on Fedora 9. 
> 
> So the issue isn't biting everyone but there is always the chance something 
> is wrong with a specific controller or configuration. 
 
FWIW, me too. I have three different Fedora 9 systems running the 
latest Fedora kernels based on 2.6.25 which are running software RAID 
1 without any issues at all. 
 
-Dave 
-- 
To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html 
 


