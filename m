From: Pavel Hofman <pavel.hofman@ivitera.com>
Subject: Re: How to update homehost of an existing raid component
Date: Mon, 19 Mar 2012 21:21:01 +0100
Message-ID: <4F67952D.80304@ivitera.com>
References: <4F670361.6090902@ivitera.com> <4F6762D6.7040602@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F6762D6.7040602@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dne 19.3.2012 17:46, John Robinson napsal(a):
> On 19/03/2012 09:58, Pavel Hofman wrote:
>> Hi,
>>
>> Please is there a way to update a homehost value for a specific raid
>> component?
> 
> I don't think you need to.
> 
> [...]
>> mdadm --verbose -A /dev/md7 --update=homehost --scan
>>
>> with no difference. Unfortunately I was not able to find how to change
>> the homehost of md6 to be local to orfeus. I do not want to force adding
>> md6 to the array and go through the whole rebuild since the data
>> themselves are OK.
> 
> 

Hi John,

Thanks a lot for your answer. Unfortunately both commands keep returning
the same result:

orfeus:~# mdadm --verbose --assemble /dev/md7 --update=homehost /dev/md5
/dev/md6
mdadm: looking for devices for /dev/md7
mdadm: /dev/md6 misses out due to wrong homehost
mdadm: /dev/md5 is identified as a member of /dev/md7, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md7
mdadm: added /dev/md5 to /dev/md7 as 1
mdadm: /dev/md7 assembled from 1 drive - need all 2 to start it (use
--run to insist).


> 
> And if that doesn't do the business, specify --homehost=orfeus

orfeus:~# mdadm --verbose --assemble /dev/md7 --update=homehost
--homehost=orfeus /dev/md5 /dev/md6
mdadm: looking for devices for /dev/md7
mdadm: /dev/md6 misses out due to wrong homehost
mdadm: /dev/md5 is identified as a member of /dev/md7, slot 1.
mdadm: no uptodate device for slot 0 of /dev/md7
mdadm: added /dev/md5 to /dev/md7 as 1
mdadm: /dev/md7 assembled from 1 drive - need all 2 to start it (use
--run to insist).

orfeus:~# mdadm --version
mdadm - v3.1.4 - 31st August 2010

orfeus:~# uname -a
Linux orfeus 2.6.26-bpo.1-amd64 #1 SMP Sat Sep 20 10:26:59 UTC 2008
x86_64 GNU/Linux


Since I need the server working (it is a company central backup server),
I forced starting md7 in degraded mode by including the --run parameter
and re-added md6 afterwards. Since both components carry the
write-intent bitmap and the degraded array was not accessed in the
meantime, md6 was re-added without any synchronization.

Still, md6 is not local to orfeus:

orfeus:~# mdadm --examine /dev/md6
/dev/md6:
....
           Name : 'orfeus':7
...

While md5 is:

orfeus:~# mdadm --examine /dev/md5
/dev/md5:
....
           Name : orfeus:7  (local to host orfeus)
....


Next time the problem will arise again. No idea how to force md6 to
become local. It looks as if md6 was created in some preliminary stage
of homehost support and its current homehost format is not supported by
the mdadm utils. Just my guess though.

John, once more thank you for your invaluable help.

Regards,


Pavel.
