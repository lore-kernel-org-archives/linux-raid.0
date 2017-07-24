From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Wrong array assembly on boot?
Date: Mon, 24 Jul 2017 15:48:29 +0100
Message-ID: <597608BD.7080108@youngman.org.uk>
References: <59739BDD.30307@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59739BDD.30307@yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/07/17 19:39, Dark Penguin wrote:
> Greetings!
> 
> I have a mirror RAID with two devices (sdc1 and sde1). It's not a root
> partition, just a RAID with some data for services running on this
> server. (I'm running Debian Jessie x86_64 with a 4.1.18 kernel.) The
> RAID is listed in /etc/mdadm, and it has an external bitmap in /RAID .

As an absolute minimum, can you please give us your version of mdadm.

And the output of "mdadm --display" of your arrays. (I think I've got
that right, I think --examine is the disk ...)

Cheers,
Wol
