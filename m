From: Keld Simonsen <keld@keldix.com>
Subject: Re: raid1 performance
Date: Mon, 26 Jul 2010 13:30:27 +0200
Message-ID: <20100726113027.GA14118@rap.rap.dk>
References: <443220.14357.qm@web28508.mail.ukl.yahoo.com>
 <20100725211926.7547c12e@natsu>
 <23123.42111.qm@web28503.mail.ukl.yahoo.com>
 <20100726102406.GA8415@rap.rap.dk>
 <4C4D6916.9060801@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C4D6916.9060801@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Marco <jjletho67-diar@yahoo.it>, Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 26, 2010 at 11:53:10AM +0100, John Robinson wrote:
> On 26/07/2010 11:24, Keld Simonsen wrote:
> [...]
> >Did you try:
> >
> ># Set read-ahead.
> >echo "Setting read-ahead to 64 MiB for /dev/md3"
> >blockdev --setra 65536 /dev/md3
> 
> That'll set read-ahead to 32MiB, because blockdev works in sectors.

Thanks for the correction, updated on wiki.

keld
