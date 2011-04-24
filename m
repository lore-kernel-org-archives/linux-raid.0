From: John Valarti <mdadmuser@gmail.com>
Subject: =?UTF-8?Q?Re=3A_Server_down=2Dfail=E2=80=8Bed_RAID5=2Dasking_for_some_assi?=
	=?UTF-8?Q?stance?=
Date: Sun, 24 Apr 2011 10:04:55 -0600
Message-ID: <BANLkTimfz_Y58yeNmF01v5ZCfCCvHc=AYQ@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110424222918.2bde0704@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 24, 2011 at 6:29 AM, NeilBrown <neilb@suse.de> wrote:

> Ahh, I see it. =A0This is a bug in there: =A0->used isn't set to zero=
 after 'dv'
> is allocated. =A0This was fixed in 3.0. =A0I don't remember that bug.=
=2E.
>
> I cannot see any easy way to work around that bug.
=2E.
> =A0on the CentOS 5.5 rescue media. I think it's
>> time to try something more recent: John, could you try SystemRescueC=
D
>> from http://www.sysresccd.org/ and run
>> =A0 =A0mdadm -Evvs
>> and if that shows your RAID5 members again,
>> =A0 =A0mdadm -Afvv /dev/md1
>
> Getting a newer mdadm is definitely a good idea.
>
> Safest to explicitly list the devices that you want
> =A0 =A0 mdadm -Afvv /dev/md1 /dev/sd[abc]2
>
>
> NeilBrown

OK, I have Fedora 14 install media handy, so I booted from that.
Once at a shell:
   mdadm --version:   3.12

mdadm -S /dev/md1
mdadm -S /dev/md1 /dev/sd[abc]2
WORKED!

cat/proc/mdstat

Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] [linea=
r]
md1 : active raid5 sdc2[0] sdb2[2] sda2[1]
      734925312 blocks level 5, 256k chunk, algorithm 2 [4/3] [UUU_]

unused devices: <none>

Rebooted the system, and it sees my RAID and my OS again.
As I write it is busy running journals and fsck
So far the only dubious part seems to be /tmp. No worry about that.

So, noe the next important part:
What to do next?
Attach another disk bigger than the RAID and copy everything to it?

Assuming yes, then what?
Speculating a bit here:

Add a new good disk and rebuild?
After that, remove the other disk that failed and we just forced back,
and rebuild again?
Then work my way through the other 2 old disks and rebuild 2 more time?

If yes, I could use some command line syntax to make sure I do it the
right way..

If "no" I am all ears as to what to do next.

Oh, and btw:
Thank you
Happy Easter.

--
John V
In a much better mood today.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
