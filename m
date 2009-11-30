From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: [PATCH v2] ppc440spe-adma: adds updated ppc440spe adma driver
Date: Mon, 30 Nov 2009 10:17:09 -0800
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C08642D18@SDCEXCHANGE01.ad.amcc.com>
References: <1259186722-15012-1-git-send-email-agust@denx.de><AC5E1C3367E37D44970B81A6ADD1DA2C08642A43@SDCEXCHANGE01.ad.amcc.com>
	<20091127112641.5bcb9009@wker>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
Content-class: urn:content-classes:message
In-Reply-To: <20091127112641.5bcb9009@wker>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
To: Anatolij Gustschin <agust@denx.de>
Cc: wd@denx.de, dzu@denx.de, Yuri Tikhonov <yur@emcraft.com>, linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

Sorry I meant drver/. Probably you should consider how the iop-dma is
done. 

-----Original Message-----
From: Anatolij Gustschin [mailto:agust@denx.de] 
Sent: Friday, November 27, 2009 2:27 AM
To: Tirumala Reddy Marri
Cc: linux-raid@vger.kernel.org; wd@denx.de; dzu@denx.de; Yuri Tikhonov;
linuxppc-dev@ozlabs.org; dan.j.williams@intel.com
Subject: Re: [PATCH v2] ppc440spe-adma: adds updated ppc440spe adma
driver

"Tirumala Reddy Marri" <tmarri@amcc.com> wrote:

> Why are we having separate directory for 440spe. Can this be
generalized
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
