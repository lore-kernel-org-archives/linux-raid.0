From: Mathias Buren <mathias.buren@gmail.com>
Subject: Re: raid5:bad sectors after lost power
Date: Thu, 13 Sep 2012 16:57:35 +0800
Message-ID: <50519FFF.5010809@gmail.com>
References: <50519cb3.21bf440a.60ca.ffffa83b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50519cb3.21bf440a.60ca.ffffa83b@mx.google.com>
Sender: linux-raid-owner@vger.kernel.org
To: vincent <hanguozhong@meganovo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/09/12 16:43, vincent wrote:
> Hi everyone:
>      I have a problem about raid5.
>      I created a raid5 with the command =E2=80=9Cmdadm =E2=80=93Cv --=
chuck=3D128 /dev/md0 =E2=80=93
> l5 =E2=80=93n4 sd[abcd]=E2=80=9D for write performance test, the capa=
city of each disk is
> 2TB. After the array was created, I modified the strip_catch_size of =
it to
> 2048.
>      Then I used a program to parallel write 150 files to the array, =
the
> speed of each is 1MB/s. Unfortunately, the electricity went off sudde=
nly at
> the time. when I turn on the device again, I found the raid5 is in re=
covery.
> When     the progress of the recovery went up to 98%, there was a wri=
te
> error occurred. I used =E2=80=9Csmartctl =E2=80=93A /dev/sd*=E2=80=9D=
 to check the heath status
> of these disks. I found the =E2=80=9CRAW_VALUE=E2=80=9D of the attrib=
ute whose name was
> =E2=80=9CCurrent_Pending_Sector=E2=80=9D of sda and sdb were 1.
> =E3=80=80=E3=80=80Then I used =E2=80=9CHDD_Regenerator=E2=80=9D to ch=
eck if there were bad blocks in the
> disks. The result of the output indicated that sda and sdb did have a=
 bad
> sector.
>      These disks were used for the first time after purchased. Is it =
normal
> to have bad sectors? Could you please help me?
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


RMA the HDDs (or return to vendor), they are not healthy.


// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
