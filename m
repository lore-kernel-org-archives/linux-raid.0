From: Robin Doherty <rdoherty@gmail.com>
Subject: Re: mdadm raid5 array - 0 space available but usage is less than capacity
Date: Thu, 23 Sep 2010 21:22:10 +0100
Message-ID: <AANLkTi=8tEoYkiEsyz5ws=0PPBWoUzyL-CiozQR-joKJ@mail.gmail.com>
References: <AANLkTi=XoxYmj8G5+GadCCTxQGJqpMttmU3NMH_vtKYM@mail.gmail.com> <20100924021845.2c7ee01b@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100924021845.2c7ee01b@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My apologies. Thanks for the responses.

Rob

On 23 September 2010 21:18, Roman Mamedov <roman@rm.pp.ru> wrote:
> On Thu, 23 Sep 2010 20:43:44 +0100
> Robin Doherty <rdoherty@gmail.com> wrote:
>
>> So maybe this is a file system problem rather than an mdadm problem?
>
> mkfs.ext3 says:
>
> =A0 =A0 =A0 -m reserved-blocks-percentage
> =A0 =A0 =A0 =A0 =A0 =A0 =A0Specify the percentage of the filesystem b=
locks reserved for the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0super-user. =A0 This =A0avoids =A0fragment=
ation, and allows root-owned
> =A0 =A0 =A0 =A0 =A0 =A0 =A0daemons, such as syslogd(8), to continue t=
o =A0function =A0correctly
> =A0 =A0 =A0 =A0 =A0 =A0 =A0after non-privileged processes are prevent=
ed from writing to the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0filesystem. =A0The default percentage is 5=
%.
>
> this can be changed on an existing FS using tune2fs.
>
> Also, this is not related to mdadm at all.
>
> --
> With respect,
> Roman
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
