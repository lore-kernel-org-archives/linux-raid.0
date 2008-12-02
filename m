From: Holger Mauermann <mauermann@gmail.com>
Subject: Re: LVM on raid10,f2 performance issues
Date: Wed, 03 Dec 2008 00:28:51 +0100
Message-ID: <4935C4B3.2060404@gmail.com>
References: <49332920.5010503@gmail.com> <20081201164244.GB23899@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081201164244.GB23899@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen schrieb:
> How is it if you use the raid10,f2 without lvm?
> What are the numbers?

After a fresh installation LVM performance is now somewhat better. I
don't know what was wrong before. However, it is still not as fast as
the raid10...

dd on raw devices
-----------------

raid10,f2:
  read : 409 MB/s
  write: 212 MB/s

raid10,f2 + lvm:
  read : 249 MB/s
  write: 158 MB/s


Holger
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
