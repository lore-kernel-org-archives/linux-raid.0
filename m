From: CoolCold <coolthecold@gmail.com>
Subject: Re: recovering from a controller failure
Date: Sun, 30 May 2010 17:17:41 +0400
Message-ID: <AANLkTim0Du0TYrTOQNajPG6IsDnj4aCvjZ3UJtZnweGW@mail.gmail.com>
References: <20100530001504.GE7501@flews.lairds.us>
	<12.2A.01646.B8CD10C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12.2A.01646.B8CD10C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: Kyler Laird <kyler-keyword-linuxraid00.a7e7f0@lairds.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 30, 2010 at 7:33 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> On Sun, May 30, 2010 at 09:50:26AM +1200, Richard wrote:
>>
>> > How about adding entries to your mdadm.conf file containing the UU=
ID
>> > of /dev/md0, eg:
>> >
>> > ARRAY /dev/md8 level=3Draid6 num-devices=3D16
>> > UUID=3D38a06a50:ce3fc204:728edfb7:4f4cdd43
>> >
>> > note this should be all one line.
>>
>> I'll be happy to do that.
>>
>> > mdadm -D /dev/md0 should get you the UUID.
>>
>> =A0 =A0 =A0 root@00144ff2a334:/# mdadm -D /dev/md0
>> =A0 =A0 =A0 mdadm: md device /dev/md0 does not appear to be active.
>>
>> So...how do I get the UUIDs? =A0I tried blkid and got this.
>> =A0 =A0 =A0 http://lairds.us/temp/ucmeng_md/uuids
>> Those UUIDs are far from unique.
>
> =A0 =A0 =A0 =A0After all your drives are visible, of course:
>
> `mdadm --examine /dev/sd* /dev/hd* > <filename>`
> `more <filename>`
>
> Make note of the array UUID for each drive. =A0When done,
>
> `mdadm --assemble --assume-clean /dev/mdX /dev/<drive0> /dev/<drive1>
> /dev/<drive2> ...etc`
>
> where <drive0>, <drive1>, etc are all members of the same array UUID.
>
> =A0 =A0 =A0 =A0Mount the file system, and fsck it. =A0Once everything=
 is verified
> good,
>
> `echo repair > /sys/block/mdX/md/sync_action`
Taking in account "Events" fields are differing on disks from 1st &
2nd controller, interesting question for me - what will happen on this
"repair" ?
And what this "Events" field really means? I didn't found description
in man pages.

> `mdadm --examine --scan >> /etc/mdadm/mdadm.conf`
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
