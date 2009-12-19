From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID5 / 6 Growth
Date: Sun, 20 Dec 2009 02:59:29 +0300
Message-ID: <70ed7c3e0912191559i75bdc191p55a93568b18f1652@mail.gmail.com>
References: <88.03.04641.B353D2B4@cdptpa-omtalb.mail.rr.com>
	<4B2D6447.1070406@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B2D6447.1070406@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John,

I grew software RAID arrays with XFS on top without issues before. I
tried with the filesystem both mounted and unmounted. Never had a
problem. And XFS can't be grown unless it's mounted, so the size of
the block device is not the one causing the issue here, as the size of
the block device (array) is larger than what the filesystem is
occupying, which is normal.

After mounting the filesystem, the admin can increase the size of the
=46S to fit the newly expanded array size.

On Sun, Dec 20, 2009 at 2:39 AM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 19/12/2009 20:19, Leslie Rhorer wrote:
> [...]
>>>
>>> The reason why you can't mount even though repair suggests you do
>>> might be because of a bug in xfsprogs/libs not a complete corruptio=
n
>>> in the filesystem itself.
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0It's possible, I guess, but the diagnosti=
cs seem pretty coherent.
>> Running xfs_repair in test mode finds a small but reasonable number =
of
>> issues.
>
> Please excuse me if this is a stupid question, but is it possible any=
 of the
> apparent issues could be caused by the block device underneath the
> filesystem having changed size, so the filesystem's in some sense the=
 wrong
> size now?
>
> Cheers,
>
> John.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
