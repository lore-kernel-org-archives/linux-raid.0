From: =?UTF-8?Q?Pawe=C5=82_Brodacki?= <pawel.brodacki@googlemail.com>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Mon, 25 Jul 2011 08:39:38 +0200
Message-ID: <CACVpCE53bab08JCmxuu_tgExxT4eYZDXyL0m0Anb0_AGngfgoQ@mail.gmail.com>
References: <201107181403.49563.raid1@fuckaround.org>
	<4E26CAA7.8030201@hardwarefreak.com>
	<c5a1a83b370a0ddb063cfc828f124e6d.squirrel@fuckaround.org>
	<CAHX8RiR0MV1iL_OfrVAKGjr0gj7zxtuxFSzMijSgNfKcs0Zz0Q@mail.gmail.com>
	<CACVpCE5mVBvqFBa7VNtGDiMKRn45Wh79gHqqnOu5vE6aeWEtgg@mail.gmail.com>
	<CAHX8RiR_7Bx_jGQijBb9rb=RW=hiFgyMqfn0QGif4mDC20FXfA@mail.gmail.com>
	<CAHX8RiTYpBJWGFEdemYqE9BwmqoQeoyehM77yrpTY3OkanyD+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHX8RiTYpBJWGFEdemYqE9BwmqoQeoyehM77yrpTY3OkanyD+g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erwan Leroux <erwan.lerou@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

W dniu 21 lipca 2011 17:42 u=C5=BCytkownik Erwan Leroux
<erwan.lerou@gmail.com> napisa=C5=82:
> I search my bookmarks to find the original source, which has some
> benchmark to compare sector 63 and 64
> http://linuxconfig.org/linux-wd-ears-advanced-format
>

Thanks for the reply. I understood that the partition must start at a
multiple of 8 512B blocks, to be properly aligned at a 4KB-sector HDD.
I just didn't know, that you couldn't go below sector 64, e.g. to
start a partition at sector 16.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
