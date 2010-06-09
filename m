From: Aryeh Gregor <Simetrical+list@gmail.com>
Subject: Re: It is possible to put write cache on ssd?
Date: Wed, 9 Jun 2010 12:21:29 -0400
Message-ID: <AANLkTimMBOtusTb2GQjziBEt5XoFEBEmZmQfhWsB6Xig@mail.gmail.com>
References: <loom.20100604T102522-67@post.gmane.org>
	<4C0D44FC.8020908@tmr.com>
	<loom.20100608T092726-796@post.gmane.org>
	<AANLkTikfDks6aTLal8dJLXhMlGxHtMtZ-L_r0r8IQQ4U@mail.gmail.com>
	<4C0F75B8.7020306@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C0F75B8.7020306@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: CoolCold <coolthecold@gmail.com>, Mario <mgiammarco@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 9, 2010 at 7:06 AM, MRK <mrk@shiftmail.org> wrote:
> Same problem with write-mostly/write-behind I think. I don't know how long
> is the queue that holds data already committed to the SSD and not yet
> committed to the HDD but it can't be too long. I'm reading the "man md"
> right now and it's not extremely clear on this. I have the impression the
> queue between the two it's either the /sys/block/hdddevice/queue/nr_requests
> or it uses the write-intent bitmap (if set). In case of the nr_requests,
> it's gonna be very short so the SSD can give you quick bursts but continuous
> performance will be that of the HDD.

I tried this once and posted some bonnie++ results:

https://kerneltrap.org/mailarchive/linux-raid/2010/1/31/6742263
