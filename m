From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Promise SATA TX4 300 + 3TB disks?
Date: Sun, 07 Oct 2012 23:02:34 -0500
Message-ID: <5072505A.6090200@hardwarefreak.com>
References: <818058745.20121005012826@oudeis.org> <20121005123653.0a5398e0@natsu> <506E9E77.1080002@hardwarefreak.com> <20121005145011.673f4974@natsu> <719665592.20121005153321@oudeis.org> <506F8FEC.7040402@hardwarefreak.com> <123539095.20121007193726@oudeis.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <123539095.20121007193726@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/7/2012 12:37 PM, Rainer F=FCgenstein wrote:

> this second-hand server was originally equipped with an U320 scsi
> backplane which I removed. by this the hotswap capability is lost,
> the drives will be directly connected to the AOC-SAT2-MV8 controller,
> I can live with that. nonetheless it would be nice to have a SATA
> backplane, but by googling I couldn't find one that fits into this
> chassis (blue/white AVANTEK).

Trying to locate a SATA backplane/cage/carrier for this old chassis may
be the proverbial needle in a haystack search.  Your best option here
would likely be a new 8-bay SATA hot swap chassis and PSU, such as:

http://www.newegg.com/Product/Product.aspx?Item=3DN82E16811219024
http://www.ebay.com/itm/EMACS-2U-460W-EPS12V-24-Pin-Power-Supply-P2G-64=
60P-/120995054350?pt=3DUS_Server_Power_Supplies&hash=3Ditem1c2bde030e

If your current chassis is 2U you should be able to swap the PSU over.
Slim optical drives are pretty cheap if you need an optical drive:

http://www.newegg.com/Product/Product.aspx?Item=3DN82E16827151242

Used on Ebay they're about half that price, but I'd avoid used optical
drives, for obvious reasons, especially slim models.

> tnx.

You're welcome.  Always glad to help with hardware.  Note my email
domain. ;)

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
