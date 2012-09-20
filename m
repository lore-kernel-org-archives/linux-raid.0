From: Markus Irle <tha.bear@gmail.com>
Subject: Re: Wrong array size detected after reboot
Date: Thu, 20 Sep 2012 11:53:04 +0200
Message-ID: <CAFEwywZ58nJMxd9ae66fEsWcUo94Djvhj44fg3MxFcQp_7_vpw@mail.gmail.com>
References: <CAFEwywaeGevnDMu7Do_wK+_Jgtyd0vman0804C2LyqbyzcJ9Sw@mail.gmail.com>
	<504C0462.2000609@turmel.org>
	<20120910091352.38dfdc20@notabene.brown>
	<CAFEwywaGN3cvXVAJxsWuc1-j0mfeLtKs_iqNznFQN8QA7JO8qQ@mail.gmail.com>
	<20120919114202.0ad6355b@notabene.brown>
	<CAFEwywbuH1689UStqoGOsvAh_X9afCpojKouY=Po5sXFGDFutw@mail.gmail.com>
	<20120920091109.5d950820@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120920091109.5d950820@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Thu, Sep 20, 2012 at 1:11 AM, NeilBrown <neilb@suse.de> wrote:
>
> Yes, the metadata has lots the most-significant-bit of the 'size'.
>
> So it should be sufficient to:
>   mdadm -G /dev/md2 --size 2930266432
>
> where the size is calculated as the current "used device size" plus 2^31.
> You could probably just do "--size max"
>
> This will cause a resync of the 2G of data which is probably unnecessary, but
> is awkward to avoid.

Thanks, will try.

Resyncing won't overwrite the existing data, will it?
Sorry for being overly cautious...

Cheers,
Markus
