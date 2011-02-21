From: NeilBrown <neilb@suse.de>
Subject: Re: Likely forced assemby with wrong disk during raid5 grow.
 Recoverable?
Date: Mon, 21 Feb 2011 12:03:57 +1100
Message-ID: <20110221120357.10e3f805@notabene.brown>
References: <AANLkTikhOAXQ6JAG1fK3x9V3icki8cjn0_ggyQwkGmnt@mail.gmail.com>
	<AANLkTi=5UZcMRKHTiXC3w8joh-qyi50gtTYwRf_scksW@mail.gmail.com>
	<20110220162509.2eb85a03@notabene.brown>
	<AANLkTi=-guMf-8YJDMvq9ybyY9Fppi+W0pqhH2Of=mKd@mail.gmail.com>
	<20110221115303.4862e093@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110221115303.4862e093@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Claude Nobs <claudenobs@blunet.cc>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 21 Feb 2011 11:53:03 +1100 NeilBrown <neilb@suse.de> wrote:

> % git clone git://neil.brown.name/mdadm master

No, that's wrong.  It's just

    git clone git://neil.brown.name/mdadm

NeilBrown


> % cd mdadm
> % make
> % sudo bash
> # ./mdadm -S /dev/md2
> # ./mdadm -Afvv /dev/md2 /dev/sda1 /dev/md0 /dev/md1 /dev/sdc1
