From: "James Youngman" <jay@gnu.org>
Subject: Re: Corrupt data - RAID sata_sil 3114 chip
Date: Sat, 3 Jan 2009 22:19:43 +0000
Message-ID: <c5df85930901031419s1197b6b1h5459c9bfdcc883b1@mail.gmail.com>
References: <495E01E3.9060903@sm7jqb.se>
	 <alpine.DEB.1.10.0901020741200.11852@p34.internal.lan>
	 <20090102213007.GA4349@lanczos.q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090102213007.GA4349@lanczos.q-leap.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, bengt@remove.sm7jqb.se, debian-user@lists.debian.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 2, 2009 at 9:30 PM, Bernd Schubert <bs@q-leap.de> wrote:
> Hello Bengt,
>
> sil3114 is known to cause data corruption with some disks. So far I only know
> about Seagate, but maybe there issues with newer Samsungs as well?

I've experienced data corruption with a SII 0680 ACLU144 (on an ST
Labs' A-132 card) with a pair of Seagate ST3300622A drives.  I was
using them with MD in a RAID1 configuration.

James.
