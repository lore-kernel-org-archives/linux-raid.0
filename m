From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: How to configure 36 disks ?
Date: Mon, 23 Mar 2009 15:12:57 +0100
Message-ID: <20090323151257.1c7c0a8e@harpe.intellique.com>
References: <5d96567b0903230659t734677a3pb4fd77cccb54008b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <5d96567b0903230659t734677a3pb4fd77cccb54008b@mail.gmail.com>
Sender: owner-linux-aio@kvack.org
To: Raz <raziebe@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com, linux-aio@kvack.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Le Mon, 23 Mar 2009 15:59:47 +0200
Raz <raziebe@gmail.com> =E9crivait:

> 1. redundancy. fair. less likely three disks will break in a single
> raid 2. performance. bad.
> 3. modularity. yes. grows
> 4. Size 24TB

I don't understand why you'd have a bad performance here. I usually
notice a very slight difference between LVM and linux-raid raid0 in all
practical benchmarks. Did you use LVM striping capability? You may
have to adjust readahead (using blockdev --setra) on each
device /dev/dm-X and /dev/md-X) to achieve optimal performance.


--=20
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
