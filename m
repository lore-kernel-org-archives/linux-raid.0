From: Paul Richter <iamcomcy@gmail.com>
Subject: Re: Is this RAID recoverable???
Date: Tue, 3 Jan 2012 18:22:40 +0400
Message-ID: <CAHw_BJ3qH+BgAxY3PHFUU_CH2EDf88xvn6V=rV71fzA-xUcLvw@mail.gmail.com>
References: <CAHw_BJ3fGd2ZN5ORs4+DSxz57AhT6jq7oL+cs_4MaztZX0sgUQ@mail.gmail.com>
	<20120103153757.5487e6fa@natsu>
	<4F0301F0.40206@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F0301F0.40206@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil!
Thanks for throwing in! Do you have the older default values? I
suredon't. And how do you add offsets the the --create command?
mdadm --create --assume-clean /dev/md1 --chunk=3D4096
--level=3D6--raid-devices=3D6 /dev/sdc1 /dev/sdd1 /dev/sdf1 /dev/sde1
missingmissing
Is what I am working with now.
Many thanks!
This 8TB represents the last 8 years of my life on the net. Built
thisRAID to protect that 'investment'. :'-(
TIA

Paul
On Tue, Jan 3, 2012 at 5:26 PM, Phil Turmel <philip@turmel.org> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi Paul, Roman,
>
> On 01/03/2012 04:37 AM, Roman Mamedov wrote:
>> On Tue, 3 Jan 2012 10:41:04 +0400
>> Paul Richter <iamcomcy@gmail.com> wrote:
>>
>>> Researched the net as much as possible, added this to wiki page:
>>> http://en.wikipedia.org/wiki/Mdadm#Recovering_from_a_loss_of_raid_s=
uperblock
>>
>> Oh, so it was you who originally wrote those instructions? :)
>> See http://permalink.gmane.org/gmane.linux.raid/35538
>
> I was going to cite myself ...
>
>> And also you probably mean http://en.wikipedia.org/w/index.php?title=
=3DMdadm&oldid=3D468952888#Recovering_from_a_loss_of_raid_superblock
>> because that part was nuked from the wikipedia page already.
>
> As to the original question: =C2=A0The odds are poor, but not zero. =C2=
=A0If you
> read my advice to Marcin, you know that some information from your
> original array is needed. =C2=A0Do you have any of it?
>
> The array size error that mount reports suggests that you are close
> to correct. =C2=A0I suspect the original array was created with a dif=
ferent
> data offset from the new array. =C2=A0The default for that changed ar=
ound
> mdadm v2.6.9.
>
> HTH,
>
> Phil
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.18 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
>
> iEYEARECAAYFAk8DAe4ACgkQBP+iHzflm3Ad+QCeJa7af9gammN2kGDFd+7qGMsM
> rX0An0A0GXfJR3W4J0odv4LE8/rgsa+M
> =3D8TYC
> -----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
