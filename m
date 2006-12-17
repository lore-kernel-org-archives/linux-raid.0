From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: sata badness in 2.6.20-rc1? [Was: Re: md patches in -mm]
Date: Sun, 17 Dec 2006 15:07:04 +0059
Message-ID: <45854F1F.5080201@gmail.com>
References: <20061204203410.6152efec.akpm@osdl.org> <200612161056.26830.rjw@sisk.pl> <200612161216.07669.rjw@sisk.pl> <200612171200.13075.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752672AbWLQOHl@vger.kernel.org>
In-Reply-To: <200612171200.13075.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@osdl.org>, Jeff Garzik <jeff@garzik.org>, Neil Brown <neilb@suse.de>, Jurriaan <thunder7@xs4all.nl>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>, Luben Tuikov <ltuikov@yahoo.com>
List-Id: linux-raid.ids

Rafael J. Wysocki wrote:
> Okay, I have identified the patch that causes the problem to appear, which is
> 
> fix-sense-key-medium-error-processing-and-retry.patch
> 
> With this patch reverted -rc1-mm1 is happily running on my test box.

Yes! Here too. Good work.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
