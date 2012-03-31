From: Bryan Bush <bbushvt@gmail.com>
Subject: Re: RAID6 grow failed
Date: Sat, 31 Mar 2012 19:24:48 -0400
Message-ID: <CAJ72viOGCYrMqvX2=3BzWQZpfDUeNwHEVHbXyaKbrwvrBP6wPQ@mail.gmail.com>
References: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
	<20120328151828.6988d3db@notabene.brown>
	<CAJ72viMxgfjhQiqJYVnjBQGfCq7jtegfvUY0nRdj46XDedeSjg@mail.gmail.com>
	<20120328192601.3db82133@notabene.brown>
	<CAJ72viPX1SDL2pPSkGQnujNcaoNmRposJXxaLhDkZDgFxv=-qA@mail.gmail.com>
	<CAJ72viPH9AykY-tafTChcS0ZbP0gGaiKRybafs4C4Yk-8D=g3A@mail.gmail.com>
	<20120401080036.355a8a23@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120401080036.355a8a23@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I still get the same error
mdadm: Cannot open /dev/sdl1: Device or resource busy
Thanks
-Bryan


On Sat, Mar 31, 2012 at 6:00 PM, NeilBrown <neilb@suse.de> wrote:
> On Sat, 31 Mar 2012 15:38:23 -0400 Bryan Bush <bbushvt@gmail.com> wro=
te:
>
>> I've had another md issue. =A0Not sure exactly what caused it but my
>> array is offline again. =A0The reshape completed and I was about to
>> insert a new drive to replace the one that failed on the initial
>> reshape.
>> /proc/mdstat contains
>> md1 : inactive sdk1[13](S) sdh1[9](S) sdi1[10](S) sdc1[8](S)
>> sdj1[11](S) sdb1[4](S) sdd1[6](S) sde1[7](S) sdl1[0](S) sdn1[2](S)
>> sdo1[3](S)
>> =A0 =A0 =A0 21488647746 blocks super 1.2
>>
>> "mdadm -As --verbose /dev/md1 -u fa32e2c5:e7bda20b:32af7c90:c7ee61eb=
" returns
>> mdadm: looking for devices for /dev/md1
>> <cut>
>> mdadm: /dev/sdo1 is identified as a member of /dev/md1, slot 3.
>> mdadm: /dev/sdn1 is identified as a member of /dev/md1, slot 2.
>> mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 10.
>> mdadm: /dev/sdl1 is identified as a member of /dev/md1, slot 0.
>> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 8.
>> mdadm: /dev/sdi1 is identified as a member of /dev/md1, slot 11.
>> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 12.
>> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 7.
>> mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 6.
>> mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 5.
>> mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 4.
>> mdadm: Cannot open /dev/sdl1: Device or resource busy
>
> Stop the array first. - it is half-started which confused mdadm.
> i.e
> =A0 mdadm -S /dev/md1
> =A0 mdadm -As .......
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
