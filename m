From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: systematic oops on disk failure with raid1 on SMP/serial-console
Date: Tue, 10 Jun 2003 15:58:51 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EE6387B.2A05DD20@SteelEye.com>
References: <20030610193021.GA2665@ens-lyon.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Loic Prylli <loic.prylli@ens-lyon.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Loic Prylli wrote:
> 
> Hello,
> 
> After installing raid1 support, I have tried using raidsetfaulty to see what
> will happen, and I got an oops, details of dmesg and ksymoops are at the
> end. This is on 2.4.20.

Oddly enough I believe this is the same problem that we've recently seen
on some of our systems. I think the problem has been in raid5 for a
while, and was introduced into raid1 in 2.4.19-preX with the following
patch:

http://marc.theaimsgroup.com/?l=linux-raid&m=102519544101676&w=2


Luckily, a patch to fix this problem was submitted for 2.4.21-rcX:

http://marc.theaimsgroup.com/?l=linux-raid&m=104009050217872&w=2


Does this (second) patch seem to address the problem? If so, 2.4.21
should work for you.

--
Paul
