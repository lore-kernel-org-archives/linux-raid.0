From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: checking md device parity (forced resync) - is it necessary?
Date: Wed, 06 Sep 2006 16:11:46 +0200
Message-ID: <44FED722.2050508@wpkg.org>
References: <44FD3C65.8040000@wpkg.org> <17662.54119.167225.879836@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17662.54119.167225.879836@smtp.charter.net>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Stoffel wrote:
> Tomasz> Lately I installed Debian on a Thecus n4100 machine.  It's a
> Tomasz> 600 MHz ARM storage device, and has 4 x 400 GB drives.
> 
> Interesting box... how quiet is it?  

I can't tell you if it's quiet or not, it's in the server room right 
now, and serves as a backup and iSCSI storage for Xen.

But as I still configured it and it was on my desk, it seemed a bit 
louder than a normal PC.
After all, it has 4 drives (which you have to buy separately).


> I'm thinking of one of these for
> home use, but I'll probably go with an EPIA box so I can actually
> setup a NFS/CiFS/backup/http/mysql server...

Although it has two gigabit network cards, you can't fully use them - 
the IXP3xx ARM CPU (600 MHz) allows you to only send about 25 MB/s of 
packets (measured on a loopback interface, so iSCSI LAN speeds are a bit 
lower).


> I've looked at the Irfant and the Buffalo Logic ones as well... all
> tempting.  But backups are the killer.  :]

There's also Thecus n5200, 800 MHz mobile Celeron, which you can supply 
with 5 drives... :)


-- 
Tomasz Chmielewski
http://wpkg.org
