From: "John Stoffel" <john@stoffel.org>
Subject: Re: And then there was Bryce...
Date: Thu, 8 Jun 2006 11:59:34 -0400
Message-ID: <17544.18790.382198.453845@smtp.charter.net>
References: <44877242.2060803@zeniv.linux.org.uk>
	<4487C5F6.2080107@idgmail.se>
	<4487FDA6.3000507@zeniv.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4487FDA6.3000507@zeniv.linux.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Bryce <bryce@zeniv.linux.org.uk>
Cc: Henrik Holst <henrik.holst@idgmail.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Bryce" == Bryce  <bryce@zeniv.linux.org.uk> writes:

Bryce> Ah,.. yes,, udev has helpfully remapped where all the drives I
Bryce> have were,.. and of course I've misread the log because my
Bryce> brain is so fixated on expecting drives to be where they should

Bryce> curse you UDEV!!

The problem is more likely that your /etc/mdadm/mdadm.conf file is
specifying exactly which partitions to use, instead of just doing
something like the following:

  DEVICE partitions
  ARRAY /dev/md0 level=raid1 auto=yes num-devices=2 UUID=2e078443:42b63ef5:cc179492:aecf0094

Which should do the trick for you.  Can you post your mdadm.conf file
so we can look it over?

John
