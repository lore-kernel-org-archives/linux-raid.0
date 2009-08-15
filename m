From: mark delfman <markdelfman@googlemail.com>
Subject: Re: -z not on RAID0 / MPIO hurdle
Date: Sat, 15 Aug 2009 10:33:49 +0100
Message-ID: <66781b10908150233i3093a7b0xe9cd92cdce76cc71@mail.gmail.com>
References: <66781b10908121144n1f053b57led29391534614b7@mail.gmail.com>
	 <20090814153521.GA6501@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090814153521.GA6501@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you Luca!  much appreciated

On Fri, Aug 14, 2009 at 4:35 PM, Luca Berra<bluca@comedia.it> wrote:
> On Wed, Aug 12, 2009 at 07:44:10PM +0100, mark delfman wrote:
>>
>> DM MPIO works fine also, but not on the partitions, only the whole
>> drive. =A0So when we MDadm DMx it overwrites the SdX2 partition etc.
>
> run kpartx on the dm device, it should create mappings for the single
> partitions.
> L.
>
> --
> Luca Berra -- bluca@comedia.it
> =A0 =A0 =A0 =A0Communication Media & Services S.r.l.
> =A0/"\
> =A0\ / =A0 =A0 ASCII RIBBON CAMPAIGN
> =A0X =A0 =A0 =A0 =A0AGAINST HTML MAIL
> =A0/ \
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
