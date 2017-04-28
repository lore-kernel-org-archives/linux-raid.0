From: =?UTF-8?Q?Patrik_Dahlstr=C3=B6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Fri, 28 Apr 2017 12:31:43 +0200
Message-ID: <CAHKno4DWXfOw-ejU5zfh_A8WiG7haSafNTbJLM4Ue1oTCFksyw@mail.gmail.com>
References: <20170424133946.GA7057@metamorpher.de> <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
 <20170425001614.GA3936@metamorpher.de> <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
 <20170425090122.GA4488@metamorpher.de> <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
 <20170425110807.GA5159@metamorpher.de> <5c3f7876-1b25-7020-5e7d-01776e7c9903@powerlamerz.org>
 <20170427231242.GA5138@metamorpher.de> <CAHKno4DBXT5n7wYosie_WHBhzXnHj0CFkdjv7_VAN2NVF-Ng4g@mail.gmail.com>
 <20170428095252.GA3793@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170428095252.GA3793@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-04-28 11:52 GMT+02:00, Andreas Klauer <Andreas.Klauer@metamorpher.de>:
> On Fri, Apr 28, 2017 at 09:11:45AM +0200, Patrik Dahlstr=C3=B6m wrote:
>> Is it missing a 'skip=3D<offset/1M>'  here?
>
> In this example the offset is provided by the loop devices.
>
Yes, I saw that after I sent my reply.

Can't I reduce my risks by doing it the other way around? Restore the
5 disk raid and then restart the reshape?
dd if=3D/dev/md6 bs=3D1M count=3DX/1M of=3D/dev/md5
mdadm --grow --raid-devices=3D6 /dev/md5 --add /dev/sdf
--backup-file=3D/root/grow_md5.bak

It's a bit more disk I/O, but less risk
