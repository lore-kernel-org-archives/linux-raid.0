From: "Majed B." <majedb@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Wed, 11 Nov 2009 05:52:31 +0300
Message-ID: <70ed7c3e0911101852n301cffc4wa69d299151bbc71f@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com> <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	<70ed7c3e0911101031q7184315g24ba345dd30e55fd@mail.gmail.com>
	<m3fx8m3rvd.fsf@mobydick.mine.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m3fx8m3rvd.fsf@mobydick.mine.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you Mathieu for the input.

I have seen IBM DS4800 SANs doing 600MB/s-700MB/s using a bunch of
148GB 15k RPM FC disks. though I haven't seen them being benchmarked
for IOPS.

I was reading an article from AnadTech yesterday that compared
rotational media to SSDs and they ran some stress tests. In the end,
they concluded that hardware RAID controllers were hampering the
performance because they couldn't absorb the amount of requests coming
at them from the SSDs. When they switched to software RAID (on Windows
in their test), they got almost double the performance (RAID5, 8
disks).

You can see the numbers here: http://it.anandtech.com/IT/showdoc.aspx?i=
=3D3532&p=3D9
If you're interested in the whole article, you can go to the link
above and go back to the main page using the index.

On sequential read, they achieved 1257 MB/s on a RAID 5 setup. Quite
impressive for those with video streaming applications.

On Wed, Nov 11, 2009 at 2:03 AM, Mathieu Chouquet-Stringer
<mchouque@free.fr> wrote:
> majedb@gmail.com ("Majed B.") writes:
>> Chris,
>>
>> Do you mind sharing the drive models & controllers you're using that
>> give you 800 MB/s?
>
> At work we reviewed different kind of fusion-io products (namely ioDr=
ive
> and ioDrive-Duo, 80GB and 640GB) and I could easily get 700 MB/s with
> more than 100k iops (benched using fio)...
>
> http://kb.fusionio.com/KB/a29/verifying-linux-system-performance.aspx
>
> Their results are consistent with what I saw...
>
> I didn't like the binary like driver though...
> --
> Mathieu Chouquet-Stringer =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mchouque@free.fr
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The sun itself sees not till=
 heaven clears.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 -- William Shakespeare --
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
