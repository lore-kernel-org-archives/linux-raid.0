From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: And then there was Bryce...
Date: Thu, 8 Jun 2006 10:01:57 -0700 (PDT)
Message-ID: <e69l65$86g$1@terminus.zytor.com>
References: <44877242.2060803@zeniv.linux.org.uk> <4487C5F6.2080107@idgmail.se> <4487FDA6.3000507@zeniv.linux.org.uk> <17544.18790.382198.453845@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <17544.18790.382198.453845@smtp.charter.net>
By author:    "John Stoffel" <john@stoffel.org>
In newsgroup: linux.dev.raid
> 
> The problem is more likely that your /etc/mdadm/mdadm.conf file is
> specifying exactly which partitions to use, instead of just doing
> something like the following:
> 
>   DEVICE partitions
>   ARRAY /dev/md0 level=raid1 auto=yes num-devices=2 UUID=2e078443:42b63ef5:cc179492:aecf0094
> 
> Which should do the trick for you.  Can you post your mdadm.conf file
> so we can look it over?

Hey guys, look at the syslog output again.  He's using kernel autorun.

	-hpa
