From: John Valarti <mdadmuser@gmail.com>
Subject: =?UTF-8?Q?Re=3A_Server_down=2Dfail=E2=80=8Bed_RAID5=2Dasking_for_some_assi?=
	=?UTF-8?Q?stance?=
Date: Sun, 24 Apr 2011 00:30:01 -0600
Message-ID: <BANLkTik7Odi0PitNXKL2sE4GkPZuO_7J+w@mail.gmail.com>
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
	<4DB370E1.5030602@anonymous.org.uk>
	<BANLkTikvevtAipmEtNEGdzG4rfVeOpbLxQ@mail.gmail.com>
	<4DB38726.2090805@anonymous.org.uk>
	<BANLkTi=X8hzx6TNkfJnoantkzOz5Dv4dGQ@mail.gmail.com>
	<20110424125848.6730999e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110424125848.6730999e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 23, 2011 at 8:58 PM, NeilBrown <neilb@suse.de> wrote:
=2E.
> I should have also asked for "mdadm --version".
2.6.9 10th March 2009

> However given that above, you want to:
>
> =A0 mdadm --assemble --verbose --force /dev/md1 /dev/sda2 /dev/sdb2 /=
dev/sdc2

mdadm: lookng for devices for /dev/md1
mdadm: no devices found for /dev/md1
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
