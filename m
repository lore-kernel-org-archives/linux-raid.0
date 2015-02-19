From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm raid 5 one disk overwritten file system failed
Date: Thu, 19 Feb 2015 22:15:59 +0000
Message-ID: <54E6609F.2080406@youngman.org.uk>
References: <020601d04c17$08c10290$1a4307b0$@johnandre.net> <alpine.DEB.2.02.1502191218140.4007@uplift.swm.pp.se> <021f01d04c4c$5def1740$19cd45c0$@johnandre.net> <alpine.DEB.2.02.1502191521450.4007@uplift.swm.pp.se> <54E5F5A7.3090609@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54E5F5A7.3090609@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, John Andre Taule <post@johnandre.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/02/15 14:39, Adam Goryachev wrote:
> From memory, there are filesystems which will do what you are asking
> (check that the data received from disk is correct, use multiple 'disks'
> and ensure protection from x failed drives, etc. I am certain zfs and
> btrfs both support this. (I've never used either due to stability
> concerns, but I read about them every now and then....)

When I used Pr1mes, I don't remember whether it was hardware or
software, but I believe their drives implemented some form of parity
check and recovery.

Basically, every eight-bit byte you wrote went to disk as sixteen bits -
a data byte and a parity byte. I don't know how it worked but (1) you
could reconstruct either byte from the other, and (2) for any 1-bit
error you could tell which of the data or parity bytes was corrupt. For
any 2-bit error I think you had a 90% chance of telling which byte was
corrupt - something like that anyway.

Of course, that's no use if your hacker feeds their corrupt stream
through your parity mechanism, or if 0x00000000 is valid when read from
disk.

Cheers,
Wol
