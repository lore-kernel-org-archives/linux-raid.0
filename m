From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: raid1 performance
Date: Mon, 26 Jul 2010 11:53:10 +0100
Message-ID: <4C4D6916.9060801@anonymous.org.uk>
References: <443220.14357.qm@web28508.mail.ukl.yahoo.com> <20100725211926.7547c12e@natsu> <23123.42111.qm@web28503.mail.ukl.yahoo.com> <20100726102406.GA8415@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100726102406.GA8415@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: Marco <jjletho67-diar@yahoo.it>, Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/07/2010 11:24, Keld Simonsen wrote:
[...]
> Did you try:
>
> # Set read-ahead.
> echo "Setting read-ahead to 64 MiB for /dev/md3"
> blockdev --setra 65536 /dev/md3

That'll set read-ahead to 32MiB, because blockdev works in sectors.

Cheers,

John.
