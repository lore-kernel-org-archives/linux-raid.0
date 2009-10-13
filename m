From: mark delfman <markdelfman@googlemail.com>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Tue, 13 Oct 2009 22:52:04 +0100
Message-ID: <66781b10910131452n10f6e1c3t5522fe0d56a187b@mail.gmail.com>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
	 <4AD3F64F.6070908@sauce.co.nz> <4AD454A0.3050704@shiftmail.org>
	 <4AD4DAA4.4080703@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AD4DAA4.4080703@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is the same experience we have, without a doubt the =91dumb=92 LSI
SAS cards + MD are certainly faster and more flexible (actually, I
should say MD is faster and more flexible).

The LSI SAS2 chips scale up better via the expanders (even if the
expanders / drives are SAS1)

BUT =96 problem with all this performance, is it is disappointing when
we lose it on XFS :(




On Tue, Oct 13, 2009 at 8:53 PM, Richard Scobie <richard@sauce.co.nz> w=
rote:
> Asdo wrote:
>
>> Do you think it was controller's overhead? I have heard mixed opinio=
ns
>> about 3wares. What are the fastest controllers around for MD-raid us=
e?
>
> The fastest setup I have found have been LSI SAS cards - LSISAS3442E-=
R, with
> the onboard RAID firmware replaced with the IT firmware.
>
> This is connected to port expander based JBOD chassis loaded with eit=
her
> =A0SAS or SATA drives.
>
> Regards,
>
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
