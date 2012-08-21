From: =?UTF-8?B?U2VyZ2l1c3ogQnJ6ZXppxYRza2k=?=
	<Sergiusz.Brzezinski@supersystem.pl>
Subject: Re: mdadm --monitor: need extra feature?
Date: Tue, 21 Aug 2012 13:51:48 +0200
Message-ID: <50337654.9000905@supersystem.pl>
References: <503365EB.6000006@supersystem.pl> <503366A1.9030307@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <503366A1.9030307@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



W dniu 21.08.2012 12:44, David Brown pisze:
> On 21/08/2012 12:41, Sergiusz Brzezi=C5=84ski wrote:
>> Hi,
>>
>> I use Raid1 to make backup of the whole system.
>
> Raid is not a backup system. It is to improve uptimes, minimise downt=
imes due to
> disk failures, and possibly to improve disk speed and/or capacity.
>
> I would recommend you first think about what you are trying to achiev=
e here -
> what are you trying to back up, how do you see restores being used, h=
ow
> efficiently are you using your hardware, your bandwidth, your time an=
d effort?
>
> You would probably be better off with a normal fixed 2-disk raid1 to =
minimise
> the problems caused by a single disk failure, combined with an rsync =
snapshot
> style backup that can be fully automated and give quick and easy reco=
very of
> multiple old versions of files in the face of the most common cause o=
f data loss
> - human error.
[...]

I know, I know. Raid is not a backup system :)

Or better: it is not intended to be a backup system.

But I do use Raid1 as backup solution because I don't know another back=
up=20
solution giving me together:
- so simple configuration (there is no configuration!)
- so low cost (no software cost, only hdd cost)
- complete copy of the whole system (not only data but also configurati=
on)
- so quick start in case of hardware failure
- so fast backup process without excessive system load
- so simple handling (just remove and insert hdd with hot-swap bay)

With some more rotating disks it can simulate very good backup solution=
s and I=20
still can make backups of critical data (dumping databases, copying fil=
es)=20
independently of Raid (and I do it).

And even I You don't want using it as a regular backup it is alwas wort=
h to do a=20
bootable disk with mirrored system partition and keep it somewhere out =
of the=20
box for the bad times - just a small system backup for quick start in c=
ase of=20
hardware failure.

So, maybye Raid 1 is not a backup system but for some cases this is the=
 best=20
backup solution it can be! And I am an opportunist :)

Sergiusz

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
