From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: man mdadm - suggested correction.
Date: Mon, 05 Nov 2007 21:08:55 +0300
Message-ID: <472F5C37.9030900@msgid.tls.msk.ru>
References: <20071104170502.6db7fcb1@absurd> <20071105115803.633f9b6b@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071105115803.633f9b6b@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki wrote:
[]
> Can you please add do the manual under 'SEE ALSO' a reference
> to /usr/share/doc/mdadm ?

/usr/share/doc/mdadm is Debian-specific (well.. not sure it's really
Debian (or something derived from it) -- some other distros may use
the same naming scheme, too).  Other distributions may place the
files into a different directory, or not ship them at all, or ship
them in alternative package.

In any case, say, on Debian a user always knows that other misc.
docs are in /usr/share/doc/$package - even if no other links are
provided in the manpage.  Users familiar with other distributions
knows where/how to find other docs there.

/mjt
