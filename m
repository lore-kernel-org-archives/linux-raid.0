From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 0/7] Add TRIM support for raid linear/0/1/10
Date: Tue, 13 Mar 2012 22:15:50 +0800
Message-ID: <CANejiEWYCxY_hLwgyN08_cXC64c82irkNPytTjOpYyER7pTGow@mail.gmail.com>
References: <20120312030412.375458948@fusionio.com>
	<alpine.LRH.2.02.1203121806120.23719@diagnostix.dwd.de>
	<4F5EFEB6.4060402@kernel.org>
	<alpine.LRH.2.02.1203131213480.15848@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1203131213480.15848@diagnostix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-raid.ids

2012/3/13 Holger Kiehl <Holger.Kiehl@dwd.de>:
> On Tue, 13 Mar 2012, Shaohua Li wrote:
>
>> On 3/13/12 2:22 AM, Holger Kiehl wrote:
>> > Hello,
>> >
>> > On Mon, 12 Mar 2012, Shaohua Li wrote:
>> >
>> >> The patches add TRIM support for raid linear/0/1/10. I'll add TRI=
M
>> support for
>> >> raid 4/5/6 later. The implementation is pretty straightforward an=
d
>> >> self-explained.
>> >>
>> > First, thanks for this patch!
>> >
>> > I have applied those patches against 3.3.0-rc7 and during boot the
>> > kernel
>> > reports a lot of the following:
>> >
>> > Mar 12 18:56:00 c3po kernel: [ 7.611045] md/raid0:md3: make_reques=
t bug:
>> can't convert block across chunks or bigger than 512k 18861064 512
>> > Mar 12 18:56:00 c3po kernel: [ 7.611047] md/raid0:md3: make_reques=
t bug:
>> can't convert block across chunks or bigger than 512k 18862088 512
>> > Mar 12 18:56:00 c3po kernel: [ 7.611049] md/raid0:md3: make_reques=
t bug:
>> can't convert block across chunks or bigger than 512k 18863112 512
>> > Mar 12 18:56:00 c3po kernel: [ 7.611052] md/raid0:md3: make_reques=
t bug:
>> can't convert block across chunks or bigger than 512k 18864136 512
>> > Mar 12 18:56:00 c3po kernel: [ 7.611054] md/raid0:md3: make_reques=
t bug:
>> can't convert block across chunks or bigger than 512k 18865160 512
>> > Mar 12 18:56:00 c3po kernel: [ 7.611056] md/raid0:md3: make_reques=
t bug:
>> can't convert block across chunks or bigger than 512k 18866184 512
>> Looks our SMTP server does something stupid. Sorry if you get two co=
pies
>> of the mail.
>>
>> Thanks for testing. Looks I fixed a sanity check in bio.c but there =
are
>> similar check in raid0/10 which I forgot to fix. Below patch should =
fix
>> it.
>> please try.
>>
> Now I get following messages during boot (and it takes a very long ti=
me):
>
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.355041] =A0 bio ffff88019e0=
abc70,
> biotail ffff88019e0ddc00, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.355052] request botched: de=
v sdb:
> type=3D1, flags=3D916c081
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.355054] =A0 sector 52929353=
, nr/cnr 0/8
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.355055] =A0 bio ffff88019e0=
aba70,
> biotail ffff88019e0dda00, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.355068] request botched: de=
v sdc:
> type=3D1, flags=3D916c081
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.355069] =A0 sector 52929346=
, nr/cnr
> 0/1016
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.355071] =A0 bio ffff88019e0=
aae00,
> biotail ffff88019e0db380, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.373583] request botched: de=
v sda:
> type=3D1, flags=3D916c081
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.373585] =A0 sector 52929354=
, nr/cnr
> 0/1016
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.373587] =A0 bio ffff88019e0=
aba00,
> biotail ffff88019e0ddc00, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.373597] request botched: de=
v sdb:
> type=3D1, flags=3D916c081
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.373599] =A0 sector 52929354=
, nr/cnr
> 0/1016
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.373600] =A0 bio ffff88019e0=
ab800,
> biotail ffff88019e0dda00, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.373612] request botched: de=
v sdc:
> type=3D1, flags=3D916c081
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.373614] =A0 sector 52929347=
, nr/cnr 0/8
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.373616] =A0 bio ffff88019e0=
aaa70,
> biotail ffff88019e0db380, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.392135] request botched: de=
v sda:
> type=3D1, flags=3D916c081
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.392137] =A0 sector 52929355=
, nr/cnr 0/8
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.392139] =A0 bio ffff88019e0=
ab670,
> biotail ffff88019e0ddc00, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.392150] request botched: de=
v sdb:
> type=3D1, flags=3D916c081
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.392152] =A0 sector 52929355=
, nr/cnr 0/8
> =A0 Mar 13 10:23:25 c3po kernel: [ =A0251.392153] =A0 bio ffff88019e0=
ab470,
> biotail ffff88019e0dda00, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
>
> After boot the system runs fine, but as soon as I do something (make =
clean
> of
> kernel tree with a sync) I get the same messages as above and it take=
s a
> long time to sync:
>
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.740528] request botched: dev =
sda:
> type=3D1, flags=3D9164081
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.740533] =A0 sector 12580617, =
nr/cnr
> 0/776
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.740537] =A0 bio ffff8801a362b=
670,
> biotail ffff8801a30f3d80, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.747141] request botched: dev =
sdb:
> type=3D1, flags=3D9164081
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.747144] =A0 sector 12579841, =
nr/cnr
> 0/248
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.747148] =A0 bio ffff88019e0dd=
200,
> biotail ffff88019e0dd200, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.749429] request botched: dev =
sdc:
> type=3D1, flags=3D9164081
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.749432] =A0 sector 12579841, =
nr/cnr
> 0/248
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.749436] =A0 bio ffff8801a362b=
600,
> biotail ffff8801a362b600, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.755332] request botched: dev =
sda:
> type=3D1, flags=3D916c081
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.755335] =A0 sector 12580618, =
nr/cnr
> 0/248
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.755339] =A0 bio ffff8801a30f3=
d80,
> biotail ffff8801a30f3d80, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.806832] request botched: dev =
sdb:
> type=3D1, flags=3D9164081
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.806836] =A0 sector 12266497, =
nr/cnr
> 0/1000
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.806840] =A0 bio ffff8801a4dca=
800,
> biotail ffff88019e0c9000, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.811972] request botched: dev =
sda:
> type=3D1, flags=3D9164081
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.811976] =A0 sector 12266497, =
nr/cnr
> 0/1000
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.811979] =A0 bio ffff88019e0dd=
200,
> biotail ffff8801a3794000, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.814081] request botched: dev =
sdc:
> type=3D1, flags=3D9164081
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.814084] =A0 sector 12265497, =
nr/cnr 0/24
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.814087] =A0 bio ffff8801a4dca=
870,
> biotail ffff8801a37f4080, buffer =A0 =A0 =A0 =A0 =A0 (null), len 0
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.819150] request botched: dev =
sdc:
> type=3D1, flags=3D916c081
> =A0 Mar 13 10:44:59 c3po kernel: [ 1550.819153] =A0 sector 12265498, =
nr/cnr
> 0/1000
>
> Please give me any hints what I can try next.
Thanks for testing. This is very wield, the req->__data_len is wrong.
Is this a clean build?
didn't success to reproduce it, will check tomorrow again.

Thanks,
Shaohua
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
