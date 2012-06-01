From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Fri, 1 Jun 2012 11:15:32 +0800
Message-ID: <CA+sTkh4+MKYaXwYe13F6Gy4VZbT0bXZpC79Bgcn1a3ZSzqwq8A@mail.gmail.com>
References: <20120531083158.GE3867@bitfolk.com> <4FC81B85.8090807@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC81B85.8090807@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1 June 2012 09:31, Stan Hoeppner <stan@hardwarefreak.com> wrote:
[=E2=80=A6]
> You could probably expect it to be more reliable if you used RAID as
> it's meant to be used, which in this case would be a single RAID10 ar=
ray
> using none, or only one partition per disk, instead of creating 4 or =
5
> different md RAID arrays from 4-5 partitions on each disk. =C2=A0This=
 is
> simply silly, and it's dangerous if doing so inside VMs.

   =E2=80=94 How do you know those RAIDs are inside VMs?

--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
