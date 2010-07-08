From: =?UTF-8?B?VMOzdGggQ3NhYmE=?= <csaba.toth@i3rendszerhaz.hu>
Subject: Re: convert raid10 to raid0
Date: Thu, 08 Jul 2010 10:27:46 +0200
Message-ID: <4C358C02.7020109@i3rendszerhaz.hu>
References: <4C34D5AD.5020305@i3rendszerhaz.hu> <20100708085034.2bc8272e@notabene.brown> <4C35852E.5060400@i3rendszerhaz.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C35852E.5060400@i3rendszerhaz.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010.07.08. 9:58 keltez=C3=A9ssel, T=C3=B3th Csaba =C3=ADrta:
> 2010.07.08. 0:50 keltez=C3=A9ssel, Neil Brown =C3=ADrta:
>> Then after you create the raid0, use the same command
>>    mdadm -E /dev/sdc6
>> to check the Data Offset again and make sure it is the same.
>> I suspect it will be, so everything will be fine.
>> However if it isn't don't try to access the array.   Post the detail=
s and I'll
>> figure out what to do next.
>>
>=20
> It doesn't work, [...]

forget to explain what i did: my idea was to create a new array with
--assume-clean, than kick out the knowed bad members:

minerva data-bck # mdadm --create /dev/md5 --assume-clean --metadata=3D=
1.1
--level=3D10 --raid-devices=3D4 /dev/sdb6 /dev/sda6 /dev/sdc6 /dev/sdd6
mdadm: /dev/sdb6 appears to be part of a raid array:
    level=3Draid10 devices=3D4 ctime=3DThu Jul  8 09:47:43 2010
mdadm: /dev/sda6 appears to be part of a raid array:
    level=3Draid10 devices=3D4 ctime=3DThu Jul  8 09:47:43 2010
mdadm: /dev/sdc6 appears to be part of a raid array:
    level=3Draid10 devices=3D4 ctime=3DThu Jul  8 09:47:43 2010
mdadm: /dev/sdd6 appears to be part of a raid array:
    level=3Draid10 devices=3D4 ctime=3DThu Jul  8 09:47:43 2010
Continue creating array? yes
mdadm: array /dev/md5 started.
minerva data-bck #
minerva data-bck # man mdadm
minerva data-bck # mdadm /dev/md5 --fail /dev/sda6 --fail /dev/sdc6
mdadm: set /dev/sda6 faulty in /dev/md5
mdadm: set /dev/sdc6 faulty in /dev/md5
minerva data-bck # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath] [faulty]
md5 : active raid10 sdd6[3] sdc6[2](F) sda6[1](F) sdb6[0]
      1434617856 blocks super 1.1 512K chunks 2 near-copies [4/2] [U__U=
]


this is exactly the same layout as i had before, just the data offset
doesn't match.

regards,
Csaba
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
