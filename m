From: Asif Iqbal <vadud3@gmail.com>
Subject: Re: remove one md and add its disk to the other md
Date: Wed, 8 Feb 2012 19:57:13 -0500
Message-ID: <CAOHBbgV2+JN=jMp-zwmXPKLjXOnn+nktW1WrDPx0yZgjvApdCw@mail.gmail.com>
References: <CAOHBbgWzHUUMeQSeXDGJv1+Na=8oM3iB1VN7mMUvhHqgLaU1dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOHBbgWzHUUMeQSeXDGJv1+Na=8oM3iB1VN7mMUvhHqgLaU1dw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 8, 2012 at 5:21 PM, Asif Iqbal <vadud3@gmail.com> wrote:
> Hi All
>
> I have two raid10s
>
> md3 : active raid10 sdh2[3] sdf2[1] sdg2[2] sde2[0]
> =A0 =A0 =A0143371392 blocks 64K chunks 2 near-copies [4/4] [UUUU]
>
> md2 : active raid10 sdg1[4] sdc1[0] sdd1[1] sdh1[5] sdf1[3] sde1[2]
> =A0 =A0 =A0214684224 blocks 64K chunks 2 near-copies [6/6] [UUUUUU]
>
>
> I like to remove md3 and add its slices to md2. All the slices are of
> same sizes.
>
> Then I like to make sure PV recognizes the size increase.
>
> root@apa-splunk-02:~# pvdisplay /dev/md2
> =A0--- Physical volume ---
> =A0PV Name =A0 =A0 =A0 =A0 =A0 =A0 =A0 /dev/md2
> =A0VG Name =A0 =A0 =A0 =A0 =A0 =A0 =A0 splunk
> =A0PV Size =A0 =A0 =A0 =A0 =A0 =A0 =A0 204.74 GiB / not usable 576.00=
 KiB
> =A0Allocatable =A0 =A0 =A0 =A0 =A0 yes
> =A0PE Size =A0 =A0 =A0 =A0 =A0 =A0 =A0 4.00 MiB
> =A0Total PE =A0 =A0 =A0 =A0 =A0 =A0 =A052413
> =A0Free PE =A0 =A0 =A0 =A0 =A0 =A0 =A0 1213
> =A0Allocated PE =A0 =A0 =A0 =A0 =A051200
> =A0PV UUID =A0 =A0 =A0 =A0 =A0 =A0 =A0 S3QuJK-dSU5-cjZZ-mcHe-dyux-V3Q=
o-YIe2oO
>
> What is recommended way to do it? I am using ubuntu lucid server lts =
64bit
>
> Thanks for your help

never mind.

I found it easier to just create another PV /dev/md3 and then vgextend =
the VG
by adding the new PV into it.


>
>
> --
> Asif Iqbal
> PGP Key: 0xE62693C5 KeyServer: pgp.mit.edu
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?



--=20
Asif Iqbal
PGP Key: 0xE62693C5 KeyServer: pgp.mit.edu
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
