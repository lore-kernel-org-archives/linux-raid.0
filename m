From: hpa@zytor.com (H. Peter Anvin)
Subject: Re: Forcing a more random uuid (random seed bug)
Date: Tue, 22 Feb 2005 23:55:50 +0000 (UTC)
Message-ID: <cvggq6$721$1@terminus.zytor.com>
References: <200502011847.39444.niccolo@texnet.it> <200502021433.42108.niccolo@texnet.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <200502021433.42108.niccolo@texnet.it>
By author:    Niccolo Rigacci <niccolo@texnet.it>
In newsgroup: linux.dev.raid
>
> > I get /dev/md5, /dev/md6, /dev/md7
> > and /dev/md8 all with the same UUID!
> 
> It seems that there is a bug in mdadm: when generating the UUID for a 
> volume, the random() function is called, but the random sequence is never 
> initialized.
> 
> The result is that every volume created with mdadm has an uuid of:
> 6b8b4567:327b23c6:643c9869:66334873
> 
> See also Debian bug 292784 at
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=292784
> 
> I fixed the problem adding the following patch to mdadm.c, but please bear 
> in mind that I'm totally unaware of mdadm code and quite naive in C 
> programming:
> 

Please don't use (s)random at all, except as a possible fallback to
/dev/(u)random.

	-hpa
