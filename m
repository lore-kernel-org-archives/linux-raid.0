From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Do I have a bad HDD?
Date: Mon, 22 Aug 2011 18:10:26 +0100
Message-ID: <CADNH=7F6sCeavTvG0ATFCqNUgV9w0QV5RF7m8O7Ry2SAtJrOGQ@mail.gmail.com>
References: <CADNH=7HDCwtUr-HSN7fH_GSH8jTYb-SAwmKY0ZRn3opWAhKiBQ@mail.gmail.com>
	<CADNH=7EJ7tvw2DEsAbeuxxRO1k961RSV4axgvfRUBaKG+Q455Q@mail.gmail.com>
	<CADNH=7EHAyk7Z7Wa72XO=p1od6AQP5aew_W5DffgLfZeCu=d-g@mail.gmail.com>
	<CADNH=7F3CVZ6r56jFrSHoVyzOZTHCfXPE_j-Rn8powbB6BLBYQ@mail.gmail.com>
	<4E359E26.2080500@truschnigg.info>
	<CADNH=7FmDpRhYbXGMJ=h17x=7hKL-=Wpoydnca=VAkLGqCfSFQ@mail.gmail.com>
	<4E35E872.2000704@turmel.org>
	<CADNH=7FG4dy3dh_U4jPq1L_TkY5Do3EN9V6OpxbyBBtHPoQxDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7FG4dy3dh_U4jPq1L_TkY5Do3EN9V6OpxbyBBtHPoQxDg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1 August 2011 00:56, Mathias Bur=C3=A9n <mathias.buren@gmail.com> wr=
ote:
> On 1 August 2011 00:42, Phil Turmel <philip@turmel.org> wrote:
>> Good evening Mathias,
>>
>> On 07/31/2011 02:31 PM, Mathias Bur=C3=A9n wrote:
>>
>> [trim]
>>
>>> No I don't have a backup ;), perhaps it's time to get one. This isn=
't
>>> super important data, more like "nice to have".
>>>
>>> I don't have any hotplug bays or anything like that (you'll see in =
a
>>> while after I put up the pictures) so I shut down the system to tak=
e
>>> the faulty HDD out.
>>>
>>> Is it wise to run a check on the array while it's degraded by 1 HDD=
?
>>
>> It shouldn't hurt your array, other than a bit of exercise. =C2=A0If=
 another
>> drive is marginal, it could conceivably "push it over the edge".
>>
>> Any positive value it has will occur anyways during the resync with =
the
>> replacement drive for sdh.
>>
>> I wouldn't bother running the scrub until the resync is finished.
>>
>> Phil
>>
>
>
> Thanks, I'll wait to scrub until I get the new HDD (hopefully within =
2
> weeks). Pics of the beast here: http://stuff3.imgur.com/htpcnas
>
> /Mathias
>

New HDD received from Samsung via RMA, all went fine adding it, now
the array is in recovery:

root@ion ~ $ mdadm --manage /dev/md0 --add /dev/sdh1
mdadm: added /dev/sdh1
root@ion ~ $ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdh1[8] sdf1[5] sde1[7] sdg1[0] sdd1[4] sdb1[1] sdc1=
[3]
     9751756800 blocks super 1.2 level 6, 64k chunk, algorithm 2
[7/6] [UUUUU_U]
     [>....................]  recovery =3D  0.0% (87852/1950351360)
finish=3D1109.9min speed=3D29284K/sec

unused devices: <none>

Thanks for all the help.

/Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
