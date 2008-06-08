From: David Greaves <david@dgreaves.com>
Subject: Re: Rebuild after a drive replacement
Date: Sun, 08 Jun 2008 22:32:26 +0100
Message-ID: <484C4FEA.7040808@dgreaves.com>
References: <1212958349.7596.14.camel@gdh-home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1212958349.7596.14.camel@gdh-home>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Hamill <gdh@acentral.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gavin Hamill wrote:
> Hi :)
> 
> I've had a drive die recently, and took the opportunity to upgrade my
> aging Debian sarge box to etch. Once the new OS was running and I had
> finished beating booting from /dev/md0 with a blunt instrument, I turned
> my attention to the data raid-sets... there's only one I can't sort out,
> and of course.. it's the biggest one :)
> 
> eddie:~# cat /proc/mdstat 
> Personalities : [raid1] [raid6] [raid5] [raid4] 
> md3 : active raid5 hda4[1] hdg4[2]
>       349702144 blocks level 5, 1024k chunk, algorithm 0 [3/2] [_UU]
> 
> eddie:~# mdadm --add /dev/md3 /dev/hde5
try:
  mdadm /dev/md3 --add /dev/hde5

David


