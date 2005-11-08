From: Troels Bang Jensen <marvin@fnuck.dk>
Subject: Re: RAID 5 array keeps dropping drive on boot
Date: Tue, 8 Nov 2005 01:12:50 +0100
Message-ID: <D8682F09-5A4D-4356-8FA6-825880F93AE4@fnuck.dk>
References: <2A807893-B5A6-4EF1-B862-1D6F22D71B60@fnuck.dk> <17263.57266.902113.362087@cse.unsw.edu.au> <5DD8751D-7FE2-4179-9887-853A704DE0D6@fnuck.dk> <17263.59743.163989.959271@cse.unsw.edu.au>
Mime-Version: 1.0 (Apple Message framework v734)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17263.59743.163989.959271@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




> So I read your original email again and see:
>
>
>> I just tried rebooting during a synchronization (had to move the
>> computer), and the state of /dev/hdc3 is now:
>>
> ...
>
>> ...but it's not synching.
>>
>
> I wouldn't expect it to be syncing.  You rebooted during a recovery
> (onto a spare).  This is quite different from a resync (after a crash,
> or on a newly created array).
> If you reboot during a recovery, you have to start the recovery again
> at the start.
>

Okay, I wasn't sure about that part though - but isn't it supposed to  
show up as a spare at least?

Anyway...

> Have you actually had the array completely recoverred since swapping
> hdc?
>

Definitely. I even had the computer running for a couple of days on a  
fully restored raid.

All in all I have made 4 or 5 syncs now, each taking about 9 hours.  
And I've made sure to shut down the computer cleanly afterwards.


Also, when hdc3 is marked faulty on the superblock on hda3 and hdg2,  
shouldn't hdc3's superblock be updated? It seems to me that hdc3 gets  
thoroughly ignored.

Since hdc3 is in mdadm.conf I've been under the impression that mdadm  
should at least say that it's missing.

Regards, Troels
