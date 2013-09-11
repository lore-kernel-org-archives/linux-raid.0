From: CoolCold <coolthecold@gmail.com>
Subject: Re: write-refresh md array (feature request)
Date: Wed, 11 Sep 2013 10:41:54 +0400
Message-ID: <CAGqmV7rPoZ7yorVezQn6=shTz1iqT94cgizxmGf3svVXQGVsNQ@mail.gmail.com>
References: <20130910181905.GC21530@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130910181905.GC21530@khazad-dum.debian.net>
Sender: linux-raid-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello!
You can achieve this with a bit inderect way - there are sync_min and
sync_max params which can be used to operate on certain borders of
array, more info
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/md.txt?id=refs/tags/v3.11#n579
.

On Tue, Sep 10, 2013 at 10:19 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> (please CC me on replies).
>
> I've been in several situations where it would have been helpful to be able
> to refresh weak sectors by rewriting the whole md raid component device,
> without the need to increase array failure risk through a fail+remove+add
> cycle for the component device.
>
> How difficult would it be to implement a "refresh" as a Linux md driver
> sync_action, pigging back on "check" ?
>
> Are there any drawbacks to write-refreshing component devices?
>
> --
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards,
[COOLCOLD-RIPN]
