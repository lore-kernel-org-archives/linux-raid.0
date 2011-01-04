From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Internal bitmap always 1/1
Date: Tue, 04 Jan 2011 17:20:04 +0000
Message-ID: <4D2356C4.2010004@anonymous.org.uk>
References: <AANLkTin_HZkgTb16Vzwvg93V9P6nm_dM-ZrjUnsKCEk-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin_HZkgTb16Vzwvg93V9P6nm_dM-ZrjUnsKCEk-@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/01/2011 16:51, Andrea Gelmini wrote:
> Hi all,
>     and thanks a lot for your effort on MdAdm.
>     With latest git version of mdadm tools=C2=B9 I have
>     problems with creation of internal bitmap. Doing something like t=
his:
>     ./mdadm -Ss;./mdadm --create /dev/md0 --level=3D1 --raid-devices=3D=
2
> --assume-clean --bitmap=3Dinternal /dev/sdb5 missing --auto=3Dmd -e
> 1.2;cat /proc/mdstat
>     mdadm: stopped /dev/md0
>     mdadm: /dev/sdb5 appears to be part of a raid array:
>        level=3Draid1 devices=3D2 ctime=3DTue Jan  4 17:29:06 2011
>     Continue creating array? y
>     mdadm: array /dev/md0 started.
>     Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4] =
[raid10]
>     md0 : active raid1 sdb5[0]
>        55777208 blocks super 1.2 [2/1] [U_]
>        bitmap: 1/1 pages [4KB], 65536KB chunk
>
>      I always have 1/1 pages (also with different partition sizes: 1G
> as 80G, no differences).

Why is this a problem? Your bitmap is simply too small to need more tha=
n=20
one page, whether it's a 1G or 80G. With a 16MB bitmap chunk size on a=20
2TB array I have 2 pages.

If you want to see how busy the bitmap is, try `mdadm --examine-bitmap=20
/dev/component`

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
