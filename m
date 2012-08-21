From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: mdadm --monitor: need extra feature?
Date: Tue, 21 Aug 2012 22:39:33 +1000
Message-ID: <50338185.4020003@websitemanagers.com.au>
References: <503365EB.6000006@supersystem.pl> <503366A1.9030307@hesbynett.no> <50337654.9000905@supersystem.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50337654.9000905@supersystem.pl>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?U2VyZ2l1c3ogQnJ6ZXppxYRza2k=?= <Sergiusz.Brzezinski@supersystem.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/08/12 21:51, Sergiusz Brzezi=C5=84ski wrote:
>
>
> W dniu 21.08.2012 12:44, David Brown pisze:
>> On 21/08/2012 12:41, Sergiusz Brzezi=C5=84ski wrote:
>>> Hi,
>>>
>>> I use Raid1 to make backup of the whole system.
>>
>> Raid is not a backup system. It is to improve uptimes, minimise
>> downtimes due to
>> disk failures, and possibly to improve disk speed and/or capacity.
>>
>> I would recommend you first think about what you are trying to
>> achieve here -
>> what are you trying to back up, how do you see restores being used, =
how
>> efficiently are you using your hardware, your bandwidth, your time
>> and effort?
>>
>> You would probably be better off with a normal fixed 2-disk raid1 to
>> minimise
>> the problems caused by a single disk failure, combined with an rsync
>> snapshot
>> style backup that can be fully automated and give quick and easy
>> recovery of
>> multiple old versions of files in the face of the most common cause
>> of data loss
>> - human error.
> [...]
>
> I know, I know. Raid is not a backup system :)
Aside from RAID is not a backup, perhaps the more useful suggestion
would be to use the right tool for the job...

So, again, ignoring that you possibly should not be using RAID for a
backup... how about using udev scripts to see when you plugin a drive,
and that script can check the UUID against any md arrays, and if it
matches, add it to the array....

BTW, I've used BackupPC (Linux based, free software for complete backup=
s
of linux + windows + pretty much any other OS, using hard links to
de-dupe files), which would export the most recent backup of each
machine and dump it as a plain tar.bz2 file onto external HDD, which wa=
s
auto-detected based on the following criteria (which I decided was "saf=
e
enough"):
1) Matching the UUID to a list of known UUID's for backup drives in the=
 pool
2) We could mount the first partition with a pre-determined FS type
(mount -t ext3 blah)
3) After mounting, a specific file existed (if [ -f
/mnt/archive/special_file ])
If all that matched, then we would create a new archive for the first
host, then delete any old archive for this host, repeat for all hosts,
unmount, send complete report to monitoring system.


Regards,
Adam


--=20
Adam Goryachev
Website Managers
www.websitemanagers.com.au

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
