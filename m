From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Sun, 14 Dec 2008 19:35:36 +0100
Message-ID: <200812141935.36744.Martin@lichtvoll.de>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan> <1229225480.16555.152.camel@localhost> <18757.4606.966139.10342@tree.ty.sabi.co.uk> (sfid-20081214_183524_928808_CA8411E0)
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18757.4606.966139.10342@tree.ty.sabi.co.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-xfs@oss.sgi.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am Sonntag 14 Dezember 2008 schrieb Peter Grandi:
> First of all, why are you people sending TWO copies to the XFS
> mailing list? (to both linux-xfs@oss.sgi.com and xfs@oss.sgi.com).
[...]
> > So its really more of an expectation that wc+barriers on,
> > performs better than wc+barriers off :)
>
> This is of course a misstatement: perhaps you intended to write
> that ''wc on+barriers on'' would perform better than ''wc off +
> barriers off'.

I think Redeeman said exactly that ;-). Either both on or both off.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
