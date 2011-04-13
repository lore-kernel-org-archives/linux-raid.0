From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: expand raid10
Date: Wed, 13 Apr 2011 08:15:56 +0100
Message-ID: <BANLkTimqdD39TgbghGi3hK4b1gh1FmcmdQ@mail.gmail.com>
References: <BANLkTimFwM0m3jT4mg8ZL4VvSXkbi4pU6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimFwM0m3jT4mg8ZL4VvSXkbi4pU6g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13 April 2011 05:28, Roberto Spadim <roberto@spadim.com.br> wrote:
> hi guys, today i have 2 disks raid10 far, with 2tb each disk/array
> i want to expand it to 4 disks raid10 far, with 2tb each disk and 4tb=
 array
> in other words, i will put more 2 disks of 2tb and i want more 2tb of=
 space
>
> could i do this with raid10 far layout? i=C2=B4m using ext4 at filesy=
stem
> how could i expand ext4 filesystem?
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

No, you cannot expand RAID0.

// M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
