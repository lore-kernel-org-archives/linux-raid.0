From: Phil Turmel <philip@turmel.org>
Subject: Re: md failing mechanism
Date: Fri, 22 Jan 2016 14:29:13 -0500
Message-ID: <56A28309.9080806@turmel.org>
References: <56A26E11.2090703@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A26E11.2090703@yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On 01/22/2016 12:59 PM, Dark Penguin wrote:
> Greetings,
> 
> Recently, I've had my first drive failure in a software RAID1 on a file
> server. And I was really surprised about exactly what happened; I always
> thought that when md can't process a read request from one of the
> drives, it is supposed to mark that drive as faulty and read from
> another drive; but, for some reason, it was deliberately trying to read
> from a faulty drive no matter what, which apparently caused Samba to
> wait until it's finished, and so the whole server was rendered
> inaccessible (I mean, the whole Samba).

What you've described does sound like a bug, maybe.  It also sounds
similar to traditional timeout mismatch caused by cheap desktop drives
used in a raid array.

In a properly functioning array, the normal sequence of events for a
simple failing sector is:

1) read from sector X fails and is reported by the drive to the kernel
2) kernel tells MD "read failed"
3) MD reads from different mirror or from peers & parity to reconstruct
the failed sector
4a) MD supplies reconstructed sector to upper layer/user.
4b) MD writes reconstructed sector back to failed location to fix it or
relocate it.  If this write succeeds (either case), the device stays in
the array.

The above sequence of events is disturbed when a drive takes too long in
step 1.

It would be good to see your dmesg of this event to see what failure
mode is present.

Meanwhile, some reading material for you:

http://marc.info/?l=linux-raid&m=139050322510249&w=2
http://marc.info/?l=linux-raid&m=135863964624202&w=2
http://marc.info/?l=linux-raid&m=135811522817345&w=1
http://marc.info/?l=linux-raid&m=133761065622164&w=2
http://marc.info/?l=linux-raid&m=132477199207506
http://marc.info/?l=linux-raid&m=133665797115876&w=2
http://marc.info/?l=linux-raid&m=142487508806844&w=3
http://marc.info/?l=linux-raid&m=144535576302583&w=2

