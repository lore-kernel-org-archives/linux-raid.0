From: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Subject: Re: Debian jessie - RAID 6 reshape - making no progress after >48 hours
Date: Thu, 15 Oct 2015 13:08:33 +0300
Message-ID: <CAETWcfubO7LcqpQQvXzHAjFDQ_Ziu4p6sExqaHerJSxeVCEKog@mail.gmail.com>
References: <20151014181019.6f7f9d0a@topdeck.tinsleyviaduct.com> <alpine.DEB.2.02.1510150906280.8750@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1510150906280.8750@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Phil Reynolds <phil@tinsleyviaduct.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

It seems that --backup-file option is missed.

Regards,
Alexander

On Thu, Oct 15, 2015 at 10:09 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Wed, 14 Oct 2015, Phil Reynolds wrote:
>
>> What can I safely do to move this along?
>
>
> Please check the mailing list archives from the past months, you are not
> alone in having this problem. Do not reboot your machine or stop the array
> unless you absolutely need to, it might be possible to just issue --continue
> to the array.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
