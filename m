From: Christopher Hoover <ch@murgatroid.com>
Subject: Re: unable to assemble (mostly?) clean array
Date: Sun, 8 Dec 2013 16:32:22 -0800
Message-ID: <CACw0PsYs+UwDVoPXAB6qf8j8OhU5qd8YhEeTj4Bok9aNR+bVew@mail.gmail.com>
References: <CACw0PsYr+u=YqXQJtUBLDzoppXPWCoRRLUqvgPLE4_L+V68iZw@mail.gmail.com>
 <52A5089D.3080109@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A5089D.3080109@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

yes, thanks, typo there.  that was done hastily for the e-mail.

i had tried the right thing previously and here it is again.  still no luck:


ch@snaggle:~$ sudo mdadm -E /dev/sd[defg]1 | egrep 'Events|^/dev/sd'
/dev/sdd1:
         Events : 286024
/dev/sde1:
         Events : 286011
/dev/sdf1:
         Events : 286024
/dev/sdg1:
         Events : 286024
ch@snaggle:~$ sudo mdadm --assemble --force /dev/md0  /dev/sd[dfg]1
mdadm: ignoring /dev/sdf1 as it reports /dev/sdd1 as failed
mdadm: /dev/md0 assembled from 0 drives and 2 spares - not enough to
start the array.
ch@snaggle:~$

On Sun, Dec 8, 2013 at 4:02 PM, Adam Goryachev
<adam@websitemanagers.com.au> wrote:
> On 09/12/13 10:32, Christopher Hoover wrote:
>>
>> hi folks,
>>
>> what's the safest way to get this array back into r/o mode?
>>
>> thanks,
>> -ch
>> ch@murgatroid.com
>>
>>
>> ch@snaggle:~$ sudo mdadm --examine /dev/sd[defg]1 | egrep 'Event|^/dev/sd'
>>
>> /dev/sdd1:
>>
>>           Events : 286024
>>
>> /dev/sde1:
>>
>>           Events : 286011
>>
>> /dev/sdf1:
>>
>>           Events : 286024
>>
>> /dev/sdg1:
>>
>>           Events : 286024
>>
>> ch@snaggle:~$ sudo mdadm --assemble --force  /dev/md0 /dev/sdd1
>> /dev/sde1 /sdg1
>>
>> mdadm: cannot open device /sdg1: No such file or directory
>>
>> mdadm: /sdg1 has no superblock - assembly aborted
>>
>
> I'm no expert on this, but two questions:
> Did you mean /dev/sdg1 ?
>
> Why not use sdd1, sdf1 and sdg1 since they have the correct event counts?
> Then add sde1 and allow to resync?
>
> sudo mdadm --manage /dev/md0 --stop
> sudo mdadm --assemble  /dev/md0 /dev/sd[dfg]1
> sudo mdadm --manage /dev/md0 --run
>
> Try that, and provide any output
>
>
> PS, it seems you would only need a minimum of 2 drives, and you have three
> with matching event counts, so it should be fine.
>
> Regards,
> Adam
>
> --
> Adam Goryachev
> Website Managers
> P: +61 2 8304 0000                    adam@websitemanagers.com.au
> F: +61 2 8304 0001                     www.websitemanagers.com.au
>
