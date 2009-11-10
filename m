From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Known-good LSI PCIe SAS HBAs?
Date: Wed, 11 Nov 2009 06:53:31 +1300
Message-ID: <4AF9A89B.80400@sauce.co.nz>
References: <73e903670911100854o1b48380apb5b0a86c44ae9dcb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903670911100854o1b48380apb5b0a86c44ae9dcb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kristleifur Da=F0ason wrote:

> Can anyone confirm/deny that the PCIe JBOD controllers from LSI work
> on Linux out of the box? Or give other recommendations for 8 port
> controllers in the $150-$200 range? (Or thereabouts. It'd be great to
> know about any known-good 4-port controllers for even up to $250.)

You should have no problem at all. I have used a number of the:

http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hba=
s/combo/sas3442e-r/index.html

controllers.

The only thing to watch out for, as has been discussed in the last few=20
days, is that use of smartmontools to monitor disk health on these 1068=
=20
based cards, wll cause drives to be offlined, when used with recent ker=
nels.

Regards,

Richard
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
