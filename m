From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: =?UTF-8?Q?Re=3A_Server_down=2Dfail=E2=80=8Bed_RAID5=2Dasking_for_some_assi?=
	=?UTF-8?Q?stance?=
Date: Sun, 24 Apr 2011 17:31:01 +0100
Message-ID: <BANLkTik6rNhoUpfsnL4dcfVr9bpE4iZ3Eg@mail.gmail.com>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>
	<ioq2b8$3rl$1@dough.gmane.org>
	<BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com>
	<BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>
	<20110422125734.1a68a736@notabene.brown>
	<BANLkTin0SoBzRAear8Jt+26MnVJWouXoNA@mail.gmail.com>
	<20110423074411.78fef94f@notabene.brown>
	<BANLkTik_ZY4uoV3E=ua1p+tUD9g8xqQDVg@mail.gmail.com>
	<20110423184824.55ee7893@notabene.brown>
	<BANLkTi=sCfFFfmZTzj2g8-aDNhDqVK8e-A@mail.gmail.com>
	<20110424075101.6763309f@notabene.brown>
	<BANLkTimDqEWZ6843RvekRGu4Z0XvNLgOwA@mail.gmail.com>
	<20110424125401.3de3720d@notabene.brown>
	<BANLkTi=8P75-wUBq149wiM-=XGVa2HBuvA@mail.gmail.com>
	<20110424184130.1692bce5@notabene.brown>
	<4DB41044.5020404@anonymous.org.uk>
	<20110424222918.2bde0704@notabene.brown>
	<BANLkTimfz_Y58yeNmF01v5ZCfCCvHc=AYQ@mail.gmail.com>
	<BANLkTinP8YYDxkQzcgFE9UVrQ551-Tv7Xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinP8YYDxkQzcgFE9UVrQ551-Tv7Xw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Valarti <mdadmuser@gmail.com>
Cc: NeilBrown <neilb@suse.de>, John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24 April 2011 17:15, John Valarti <mdadmuser@gmail.com> wrote:
> On Sun, Apr 24, 2011 at 10:04 AM, John Valarti <mdadmuser@gmail.com> =
wrote:
> ..
>> WORKED!
>
> It seems I spoke a bit too soon. =C2=A0sigh..
>
> fsck ran quite a while on /dev/Main/samba
>
> And then it bailed out with "an error occurred"
>
> I know this is not exactly an mdadm question at this point, but you
> folk know what you
> are doing far better than me..
>
> It dropped me to a basic root shell.
>
> Any suggestions what to try next?
>
> --
> John V
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Rescue all HDDs to HDD images and try to perform assembles/data rescue =
on them.

Run fsck manually on your array HDDs, capture the output.

Regards,
// M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
