From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Unable to assemble RAID6 after Ubuntu>Arch switch
Date: Sat, 26 Sep 2015 19:01:04 +0100
Message-ID: <CADNH=7H9DcEFEEOmcMjn1fS-2efPB_eXVN8zxCoVCHRaCpLR3Q@mail.gmail.com>
References: <CADNH=7Hr6HXVPQP6-V8Jkr9aSwqHojoWApjA7ZKnQOPL0inUYw@mail.gmail.com>
 <CAETWcfsw2M3JkNmE3M3nsr0_M4N86ta+kaRo62OgK+Ft0J5iiw@mail.gmail.com>
 <CADNH=7E796sv+A4PDb2n=EJomAR8KPRoGt-=+52BYfrELBFZDg@mail.gmail.com>
 <CAETWcfvF1o8mNVw1t-=7WNZZTz774eTnj1tG6UckrXbDvWxdXg@mail.gmail.com>
 <CADNH=7Eyy-K3ivHAt_oYtTWdkeSDA7itZ+1Y+-EHdz8Y9_U0ww@mail.gmail.com>
 <CAETWcftkkJr_MjP5ReBsOCW5ioCu81KQcdwr_1-=qUD25e1ssw@mail.gmail.com>
 <CADNH=7HEpag54Z7+aey+skWiThL93H2sgPpxVS77pqp4R_1NAQ@mail.gmail.com> <56068280.2090009@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56068280.2090009@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Alexander Afonyashin <a.afonyashin@madnet-team.ru>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26 September 2015 at 12:33, Phil Turmel <philip@turmel.org> wrote:
> On 09/26/2015 08:16 AM, Mathias Bur=C3=A9n wrote:
>> Hi,
>>
>> Would it be possible to somehow manually assemble array under Arch?
>> Since the Arch kernel doesn't see /dev/sda1 and /dev/sdb1 (fdisk see=
s
>> them but they do not appear in /dev) I can't assemble arrays.
>> partprobe doesn't help. Any ideas why the partitions wouldn't popula=
te in /dev ?
>
> Is there any chance you've managed to get a GPT label onto those disk=
s?
>  And your arch kernel has omitted GPT support?
>
> Phil
>

Good idea Phil, but it's enabled by default:

$ zgrep CONFIG_EFI_PARTITION /proc/config.gz
CONFIG_EFI_PARTITION=3Dy
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
