From: Anatolij Gustschin <agust@denx.de>
Subject: Re: [PATCH v2] ppc440spe-adma: adds updated ppc440spe adma driver
Date: Fri, 27 Nov 2009 11:26:41 +0100
Message-ID: <20091127112641.5bcb9009@wker>
References: <1259186722-15012-1-git-send-email-agust@denx.de>
	<AC5E1C3367E37D44970B81A6ADD1DA2C08642A43@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C08642A43@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org, wd@denx.de, dzu@denx.de, Yuri Tikhonov <yur@emcraft.com>, linuxppc-dev@ozlabs.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

"Tirumala Reddy Marri" <tmarri@amcc.com> wrote:

> Why are we having separate directory for 440spe. Can this be generalized
> arch/dma/ppc4xx/ppc4xx_dma.c ?

currently there is only tested support for 440spe. If the driver
will be extended to support other CPUs, then the renaming can be
done while adding support for other CPUs. 'arch/' is not correct,
it should be 'driver/'.

Best regards,
Anatolij

--
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
