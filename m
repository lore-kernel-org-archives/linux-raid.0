From: Shaohua Li <shli@kernel.org>
Subject: Re: Poor written performance with RAID5 on ARM64
Date: Tue, 19 Apr 2016 06:59:17 -0700
Message-ID: <20160419135917.GA2116@kernel.org>
References: <tencent_7B55CA2751E70C532CB35C8E@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <tencent_7B55CA2751E70C532CB35C8E@qq.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?B?5YiY5q2j5YWD?= <liuzhengyuan@kylinos.com.cn>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Apr 18, 2016 at 01:43:04PM +0800, =E5=88=98=E6=AD=A3=E5=85=83 w=
rote:
> Hi,everyone.  I upgrade kernel form 3.14.x to 4.4.x recently on my AR=
M64
> server.  I create a RAID5 device with 8 disks on the server and have =
a dd
> test which like this "dd if=3D/dev/zero of=3D/dev/md5 bs=3D64K count=3D=
400000".
> Before upgrade it can reach 700M/s written and only 500M/s after upgr=
ade.
> Then I disable the bitmap which means "mdadm create --bitmap=3Dnone",=
 the speed
> can reach 800M/s with 4.4 kernel. I have a fast view on driver/md/bit=
map.c
> and got no answer.  I doubt X86 platform has the same question. So, w=
hat is
> the most difference between 3.14.x and 4.4.x about md driver. Where c=
ould I
> found the ChangeLog or commit about the driver. Any answer would be t=
hankful.

did you observe any changes in iostat? Could you post blktrace from one=
 of the
raid disk?

Thanks,
Shaohua
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
