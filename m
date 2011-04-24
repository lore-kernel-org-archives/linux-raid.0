From: John Valarti <mdadmuser@gmail.com>
Subject: =?UTF-8?Q?Re=3A_Server_down=2Dfail=E2=80=8Bed_RAID5=2Dasking_for_some_assi?=
	=?UTF-8?Q?stance?=
Date: Sun, 24 Apr 2011 12:41:09 -0600
Message-ID: <BANLkTinBJj89C3qwP065n37ZF9=uUKgsmQ@mail.gmail.com>
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
	<BANLkTik6rNhoUpfsnL4dcfVr9bpE4iZ3Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTik6rNhoUpfsnL4dcfVr9bpE4iZ3Eg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: NeilBrown <neilb@suse.de>, John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 24, 2011 at 10:31 AM, Mathias Bur=E9n <mathias.buren@gmail.=
com> wrote:
=2E.
> Rescue all HDDs to HDD images and try to perform assembles/data rescu=
e on them.
>
> Run fsck manually on your array HDDs, capture the output.
>
> Regards,
> // M

Thanks, what I did in the meantime:
Booted again from rescue media (Fedora 14)
ran fsck on the filesystems using modern fsck.
Once they were clean, rebooted and checked and it is not OK, and boots =
to login.
Now I am installing CentOS 5.6 on new disks ( 2 x 1TB using RAID1)
Then I will reboot one more time, and selectively copy over useful
data and configuration info from
the old RAID to the new.

A VERY big "Thank You!" to all.

Enjoy your chocolate.

p.s.: Note to future:
Start with asking: "please run mdadm --version " and report back.
If less that 3.xx tell person to boot with something newer.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
