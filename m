From: =?UTF-8?B?U2VyZ2l1c3ogQnJ6ZXppxYRza2k=?=
	<Sergiusz.Brzezinski@supersystem.pl>
Subject: Re: mdadm --monitor: need extra feature?
Date: Wed, 22 Aug 2012 09:14:15 +0200
Message-ID: <503486C7.70503@supersystem.pl>
References: <503365EB.6000006@supersystem.pl> <503366A1.9030307@hesbynett.no> <50337654.9000905@supersystem.pl> <50338185.4020003@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50338185.4020003@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

W dniu 21.08.2012 14:39, Adam Goryachev pisze:
> On 21/08/12 21:51, Sergiusz Brzezi=C5=84ski wrote:
>>
>>
>> W dniu 21.08.2012 12:44, David Brown pisze:
>>> On 21/08/2012 12:41, Sergiusz Brzezi=C5=84ski wrote:
>>>> Hi,
>>>>
>>>> I use Raid1 to make backup of the whole system.
>>>
>>> Raid is not a backup system. It is to improve uptimes, minimise
>>> downtimes due to
>>> disk failures, and possibly to improve disk speed and/or capacity.
>>>
>>> I would recommend you first think about what you are trying to
>>> achieve here -
>>> what are you trying to back up, how do you see restores being used,=
 how
>>> efficiently are you using your hardware, your bandwidth, your time
>>> and effort?
>>>
>>> You would probably be better off with a normal fixed 2-disk raid1 t=
o
>>> minimise
>>> the problems caused by a single disk failure, combined with an rsyn=
c
>>> snapshot
>>> style backup that can be fully automated and give quick and easy
>>> recovery of
>>> multiple old versions of files in the face of the most common cause
>>> of data loss
>>> - human error.
>> [...]
>>
>> I know, I know. Raid is not a backup system :)
> Aside from RAID is not a backup, perhaps the more useful suggestion
> would be to use the right tool for the job...
>
> So, again, ignoring that you possibly should not be using RAID for a
> backup... how about using udev scripts to see when you plugin a drive=
,
> and that script can check the UUID against any md arrays, and if it
> matches, add it to the array....

I wrote a script making this work. It runs once a hour. I pass the para=
meter=20
with md device to the script. It checks the state of the array with "md=
adm=20
--detail". If there is something wrong (State : degraded) it reads UUID=
 of that=20
array. Then it scans for /dev/sd* partitions and checks with "mdadm --e=
xamine"=20
if UUID matches. If so, the partition can be added with "mdadm --add". =
That is=20
why I asked abut this feature in mdadm - recognising if there is a new =
partition=20
belonging to monitored array. With mdadm this procedure would work on e=
legant=20
manner.

>
> BTW, I've used BackupPC (Linux based, free software for complete back=
ups
> of linux + windows + pretty much any other OS, using hard links to
> de-dupe files), which would export the most recent backup of each
> machine and dump it as a plain tar.bz2 file onto external HDD, which =
was
> auto-detected based on the following criteria (which I decided was "s=
afe
> enough"):
> 1) Matching the UUID to a list of known UUID's for backup drives in t=
he pool
> 2) We could mount the first partition with a pre-determined FS type
> (mount -t ext3 blah)
> 3) After mounting, a specific file existed (if [ -f
> /mnt/archive/special_file ])
> If all that matched, then we would create a new archive for the first
> host, then delete any old archive for this host, repeat for all hosts=
,
> unmount, send complete report to monitoring system.
>
>
> Regards,
> Adam
>

Yes, that is probably good backup tool. (I don't know this tool, but I =
guess it=20
is :) ). In both cases (my, and Your) we can change the hdd in hot-swap=
 bay. The=20
difference is (for me it is very importand difference) that in moment o=
f=20
removing disk, You have just a backup, and I have the backup + working,=
 ready to=20
use, with most up-to-date files, system. Ok, there can be some corrupte=
d files=20
(hot-swap removing can cause this) but that is the reason for making "r=
eal=20
backup" of critical data independently of raid and storing it for examp=
le on the=20
raid device itself! I do it for example with postgres database with pg_=
dump in=20
cron. Then I rotate it with logrotate to have some more backups from th=
e past.=20
So, on my mirrored, just removed disk is the whole, probably ready for =
instant=20
use, system. In case of problems (corrupted database indices or data fi=
les for=20
example) I also have "real" backups on the disk from the past.

I don't want to argue, which solution is better. It can depend on many=20
circumstances and needs. As we sad, "Raid is not a backup system" - so =
it=20
doesn't have many features which real backup system have. I only want t=
o say,=20
that for me Raid1 is the excelent backup solution regardless of wheter =
I should=20
use Raid1 for backup or not. Fortunately no one can prohibit using Raid=
 on this=20
way :) And I just choose the solution which works for me better.

best regards

Sergiusz
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
