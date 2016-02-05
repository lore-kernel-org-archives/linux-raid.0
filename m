From: Phil Turmel <philip@turmel.org>
Subject: Re: [SOLVED] Re: Raid 1 needs repair
Date: Fri, 5 Feb 2016 11:54:00 -0500
Message-ID: <56B4D3A8.7050807@turmel.org>
References: <285536573.454192.1454595669809.JavaMail.open-xchange@app01.ox.hosteurope.de>
 <56B36577.2030902@turmel.org>
 <1161942166.457494.1454601803851.JavaMail.open-xchange@app01.ox.hosteurope.de>
 <56B38012.5020404@turmel.org>
 <43098506.459602.1454607669214.JavaMail.open-xchange@app01.ox.hosteurope.de>
 <56B3C311.5060407@turmel.org>
 <1780660272.512114.1454666577942.JavaMail.open-xchange@app02.ox.hosteurope.de>
 <1543635690.543147.1454691080103.JavaMail.open-xchange@app03.ox.hosteurope.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1543635690.543147.1454691080103.JavaMail.open-xchange@app03.ox.hosteurope.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Lamby <webmaster@peter-speer.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/05/2016 11:51 AM, Stefan Lamby wrote:
> Hi.
> I have it up and synced again.
> A simple mdadm --manage /dev/md0 --add /dev/sda1 did it, without
> anything else. No --fail no --remove no --zero-metadata needed.
> After that I "grub-install /dev/sda" and now grub is installed at both
> array members.
>  
> Thank you for your support.

Yes, that would have been my suggestion if I had caught up on my
e-mails.  I'm in the middle of a kernel bisection :-(

Phil
