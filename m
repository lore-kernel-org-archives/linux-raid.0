From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [bug?] raid1 integrity checking is broken on 2.6.18-rc4
Date: Sat, 12 Aug 2006 15:59:33 +0400
Message-ID: <44DDC2A5.6020802@tls.msk.ru>
References: <200608120252_MC3-1-C7DD-BA91@compuserve.com> <Pine.LNX.4.64.0608120512440.21701@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0608120512440.21701@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Chuck Ebbert <76306.1226@compuserve.com>, linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> Is there a doc for all of the options you can echo into the sync_action?
> I'm assuming mdadm does these as well and echo is just another way to
> run work with the array?

How about the obvious, Documentation/md.txt ?

And no, mdadm does not perform or trigger data integrity checking.

/mjt
