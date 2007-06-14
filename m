From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: below 10MB/s write on raid5
Date: Thu, 14 Jun 2007 13:15:06 +0400
Message-ID: <4671071A.8050901@msgid.tls.msk.ru>
References: <200706111446.55813.Dexter.Filmore@gmx.de>	<Pine.LNX.4.64.0706110847380.31708@p34.internal.lan>	<200706111528.11828.Dexter.Filmore@gmx.de>	<Pine.LNX.4.64.0706110928420.31708@p34.internal.lan>	<87tzteku45.fsf@hades.wkstn.nix>	<Pine.LNX.4.64.0706112134510.5806@gheavc.wnzcbav.cig> <87ir9r2ywf.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ir9r2ywf.fsf@hades.wkstn.nix>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Nix wrote:
[]
> With iflag=direct I get, um,
> 
> loki:/var/log# time dd if=/dev/md1 bs=1000 count=502400 of=/dev/null iflag=direct
> dd: reading `/dev/md1': Invalid argument

For direct i/o, you have to use blocksize =512, 1024, ... - multiple of a sector size.

/mjt
