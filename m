From: Paul Waldo <pwaldo@waldoware.com>
Subject: Re: Kernel panic during resync
Date: Tue, 15 Aug 2006 12:12:01 -0400
Message-ID: <44E1F251.9040808@waldoware.com>
References: <44DC8153.8010105@waldoware.com> <17632.62892.429563.800085@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17632.62892.429563.800085@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday August 11, pwaldo@waldoware.com wrote:
>> Hi all,
>>
>> I've got a machine with a RAID6 array which hung on me yesterday.  Upon
>> reboot, mdadm refused to start the array, since it was degraded and
>> dirty.  The array had 7 drives, and one had previously gone bad.  I'm
>> running Fedora Core 5.
>>
>> I rebooted, using the "md-mod.start_dirty_degraded=1" parameter.
>> Everything seemed to be OK--the sync process started and I watched it go
>> for about half an hour.  I came back later, and found the machine had a
>> kernel panic with the message "Kernel panic - not syncing: Fatal
>> exception in interrupt".  Just to make sure, I restarted and tried to
>> sync again, but got the same message.
>>
>> What might be causing this?  Is there any way to recover?  Thanks in
>> advance!
> 
> It is very hard to say without more details.
> Was there any stack trace?  Any other possibly related messages that
> you can report?
> 
> And what kernel (exactly) are you using?
> 
> NeilBrown

Hi Niel,

Thanks for the reply.  I resolved the issue by using a different disk. 
I had a suspicion that the disk might have some problems, but I figured 
that the sync process would work around it and give at least a warning 
or give me a message saying that the disk was unusable.  I wasn't 
expecting a panic :-O

My recollection of the stack trace was the problem was in a 
raid6-buffer-flush type of place.  Sorry I don't have any more info for 
you...

Paul
