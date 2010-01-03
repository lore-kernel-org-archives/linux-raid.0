From: Billy Crook <billycrook@gmail.com>
Subject: Re: Raid 5 to 6 reshape q
Date: Sun, 3 Jan 2010 14:14:09 -0600
Message-ID: <a43edf1b1001031214m6a4bea69ja17508b7da41efbd@mail.gmail.com>
References: <73e903671001020419x47a07e69ucb5a01b99dc1fc03@mail.gmail.com>
	<657593.18711.qm@web51308.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <657593.18711.qm@web51308.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com
Cc: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here's a couple trivial scripts I've used to pause execution until a
sync is completed.  They are handy for when you want to do multiple
grow operations, each no sooner than after the previous completed.
Modify for your own purposes.

[root@Eight bin]# cat raid-wait-till-sync-finish
#! /bin/bash

export interval=3D300

if [[ $1 -gt 0 ]]
then
	interval=3D$1
fi

echo -n Checking every ${interval} seconds for raid sync to finish.

while [[ $( cat /sys/block/md*/md/sync_action | \
            grep -v idle | \
            wc -l ) -gt 0 ]]
do
	echo -n .
	sleep ${interval}
done

echo Raid System Healthy!

exit 0
[root@Eight bin]# cat raid-wait-till-all-healthy
#! /bin/bash

export clean=3Dno
while [[ $clean=3D=3Dno ]]
do
	#set clean to yes
	clean=3Dyes

	#Give each array the chance to set clean to no
	for array in `ls -1 /sys/block/md*/md -d`
	do
	=09
		if [[ $( cat $array/raid_disks ) -gt $( ls -1 $array/ | grep
^rd[0-9]*$ | wc -l ) ]]
		then
			echo $array is still unclean
			clean=3Dno
		fi
	done
	sleep 5
done



On Sun, Jan 3, 2010 at 12:07, Jon Hardcastle <jd_hardcastle@yahoo.com> =
wrote:
>
>
>
> --- On Sat, 2/1/10, Kristleifur Da=F0ason <kristleifur@gmail.com> wro=
te:
>
>> From: Kristleifur Da=F0ason <kristleifur@gmail.com>
>> Subject: Re: Raid 5 to 6 reshape q
>> To: Jon@ehardcastle.com
>> Cc: linux-raid@vger.kernel.org
>> Date: Saturday, 2 January, 2010, 12:19
>> On Sat, Jan 2, 2010 at 8:52 AM, Jon
>> Hardcastle <jd_hardcastle@yahoo.com>
>> wrote:
>> > Hi guys, thanks for your help getting me going with
>> this over the last week. I kicked it off last night and all
>> is well.
>> > ...
>> > The only Q i have is it seems to be abit slow?
>> > ...
>> > md4 : active raid6 sdg1[4] sdf1[0] sde1[1] sdd1[2]
>> sdc1[5] sdb1[3] sda1[6]
>> > =A0 =A0 =A02441919680 blocks super 0.91 level 6, 64k
>> chunk, algorithm 18 [7/6] [UUUUUU_]
>> > =A0 =A0 =A0[=3D=3D=3D>.................] =A0reshape =3D 17.9%
>> (87600896/488383936) finish=3D2881.3min speed=3D2317K/sec
>>
>> That's very slow. An order of magnitude too slow in my
>> view. I was
>> initially seeing speeds like this during my recent reshape,
>> but got it
>> up to around 30MBps. I can't recall exactly what I did to
>> get it
>> running better - it was the equivalent of giving the
>> television a good
>> whack - but I seem to recall that increasing the md stripe
>> cache size
>> helped the most.
>>
>> I don't currently have access to my work computer where the
>> command
>> history lives, so this is all I have for now. If I find
>> anything more
>> to try, I'll chime in.
>>
>> -- Kristleifur
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>>
>
> Well it is trundling along at about that speed still if only i had kn=
ow that if i was adding 2 drives it would be much quciker as i plan to =
add another drive at the end of the week! i figured it was more to pote=
ntially go wrong!
>
> Anyways if you can suggest any commands that might speed it up i'd be=
 very grateful!
>
>
> -----------------------
> N: Jon Hardcastle
> E: Jon@eHardcastle.com
> 'Do not worry about tomorrow, for tomorrow will bring worries of its =
own.'
>
> ***********
> Please note, I am phasing out jd_hardcastle AT yahoo.com and replacin=
g it with jon AT eHardcastle.com
> ***********
>
> -----------------------
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
