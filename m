From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: doubt about raid 'quality'
Date: Tue, 17 Jul 2012 05:33:25 -0300
Message-ID: <CABYL=Tr_RAsxOVnSW-Tc11_j8QGCwzR-ca-YOrQXXigk_=YqDg@mail.gmail.com>
References: <CABYL=TobGA_eHqfLQXMnTJ8B8hPQ2B1HrBvTAdM3XAhn8x27uw@mail.gmail.com>
	<CADNH=7G7FXj7skqQ7_P54-GM6rDgAcUPBuKnFrQ6-qGbRNsf_g@mail.gmail.com>
	<CABYL=Tr=tMxmNhTz=U0bUae+f8rj+44jcnHTS0uguDqnXvJA5A@mail.gmail.com>
	<CA+sTkh5CzbpRMr=ZNgDMxdQcceQHNK_rhLGpxN_LvPab-mS2wA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh5CzbpRMr=ZNgDMxdQcceQHNK_rhLGpxN_LvPab-mS2wA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

hum, and what happen if mismatch_cnt get bigger and bigger... it=B4s a
problem? what it=B4s mean? diferent blocks on mirrors (raid1)?


2012/7/17 Igor M Podlesny <for.poige+lsr@gmail.com>
>
> On 17 July 2012 11:00, Roberto Spadim <roberto@spadim.com.br> wrote:
> > humm and how i know if the check is ok?
>
>    Kinda like that: watch -n3 cat /proc/mdstat
> /sys/block/md123/md/mismatch_cnt -- if you want to keep your finger o=
n
> its pulse, or simply cat the counter's file when it's done.
>
>    Neil, I have already thought bout it -- maybe check/repair action
> should output mismatch_cnt into dmesg's buffer after its completion?
>
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
