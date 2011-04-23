From: =?ISO-8859-1?Q?Raphael_M=FCller?= <rapmue@gmail.com>
Subject: Re: change from raid 5 to raid 6 interrupted
Date: Sat, 23 Apr 2011 17:23:55 +0200
Message-ID: <BANLkTi=vYT+3FQoxWjZ2VG9xgFTLXKiC0Q@mail.gmail.com>
References: <BANLkTikntFUK5rX1oTynY849=o-GuDL2Yg@mail.gmail.com>
	<BANLkTikBscshav-eDHHAGWh=6iuDMj=b0w@mail.gmail.com>
	<4DB1991D.1090902@anonymous.org.uk>
	<BANLkTi=4i67qxZ9ymD+VpuCszPzby57d8w@mail.gmail.com>
	<4DB19D67.1040809@anonymous.org.uk>
	<20110423080613.14189094@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110423080613.14189094@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ok thank you =3DD now it works again. but at very slow speed (~4000kb/s=
)
normally this array brings nearly 70Mb/s.

I tried different performance related stuff, like stripe_cache_size,
readaheadbuffer but nothing could bring better performance.

And i noticed that the newly added drive now is listed as spare
rebuilding. is this normal?

thanks

Raphael

2011/4/23 NeilBrown <neilb@suse.de>:
> On Fri, 22 Apr 2011 16:23:19 +0100 John Robinson
> <john.robinson@anonymous.org.uk> wrote:
>
>> (Please always remember to cc the list when replying; cc readded)
>>
>> On 22/04/2011 16:09, Raphael M=FCller wrote:
>> > Ok i forgot to say, that the backup file is also gone... (my mista=
ke)
>> >
>> > is this backup file the only option i got?
>>
>> Without the backup file you've almost certainly lost some data. I
>> suspect there is a way of restarting the array and reshape without t=
he
>> backup file, but I don't know what it is - you'll have to wait for a
>> proper guru to get back to you with an answer.
>>
>
> With mdadm 3.2.1 there is a new flag "--invalid-backup". =A0It tells =
mdadm that
> you know that the backup file is invalid, but you want it to continue=
 anyway
> (and risk having some corrupted data).
>
> You still need to give a backup file, but it can be a newly created e=
mpty
> file.
>
> So:
> =A0# install mdadm 3.2.1
> =A0> /root/my-backup
> =A0mdadm -A /dev/mdthing --backup-file=3D/root/my-backup =A0\
> =A0--invalid-backup /dev/device1 /dev/device2 ....
>
> should get you going again.
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
