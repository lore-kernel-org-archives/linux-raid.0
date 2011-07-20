From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Software RAID and TRIM
Date: Wed, 20 Jul 2011 14:25:36 +0200
Message-ID: <j06hg0$gdv$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>	 <iud06d$ad5$1@dough.gmane.org> <4E235984.2070704@5t9.de>	 <j012fa$6k6$1@dough.gmane.org> <j01ssr$j1i$1@dough.gmane.org>	 <j024fe$4va$1@dough.gmane.org> <j03ipg$uqk$1@dough.gmane.org>	 <j03m2p$jn1$1@dough.gmane.org>	 <alpine.OSX.2.00.1107191516181.275@trogdor.csi.cam.ac.uk> <1311164022.2031.0.camel@werner-t410>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1311164022.2031.0.camel@werner-t410>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/20/2011 02:13 PM, Werner Fischer wrote:
> There is a paper from Intel "Over-provisioning an Intel=C2=AE SSD" (a=
nalyzing
> X25-M 160 GB Gen.2 SSDs):
> http://cache-www.intel.com/cd/00/00/45/95/459555_459555.pdf
>
> On page 10 of this Intel presentation they mention that a spare area
>> 27% of native capacity has diminishing returns for such an SSD:
> http://maltiel-consulting.com/Enterprise_Data_Integrity_Increasing_En=
durance.pdf

(This latter document is password protected.)

The first document, though, claims almost linear benefit (regarding IOs=
/sec)
from much higher amounts of over-provisioning. Alas, their chart does n=
ot extend
into the region where saturation of the effect must occur for sure.

Regards,

Lutz Vieweg



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
