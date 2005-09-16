From: Tyler <pml@dtbb.net>
Subject: Re: Good, recent FS comparison?
Date: Fri, 16 Sep 2005 00:35:30 -0700
Message-ID: <432A75C2.2090808@dtbb.net>
References: <6d5bedd8050915131148b8108a@mail.gmail.com> <432A37BF.7060305@dtbb.net> <Pine.LNX.4.61.0509152341440.10349@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0509152341440.10349@soloth.lewis.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Lewis <jlewis@lewis.org>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jon Lewis wrote:
> What kernels/XFS versions have you had good luck with?  I have one large 
> raid with XFS, and it keeps doing:
> 
> Corruption of in-memory data detected.  Shutting down filesystem
> 
> umount/mount fixes it...for a few days.  I gave SGI's latest 2.4 kernel 
> CVS tree a try, and found it broke NFS export of XFS, so I couldn't run 
> it long enough to see if it fixed the first problem.
> 
> ----------------------------------------------------------------------
>  Jon Lewis                   |  I route
>  Senior Network Engineer     |  therefore you are
>  Atlantic Net                | _________ 
> http://www.lewis.org/~jlewis/pgp for PGP public key_________

A debian 3.1 Sarge sytem running kernel 2.6.11.7 (vanilla), and xfsprogs 
v2.6.28-1.

I did a search on google for those errors.. the ones I spotted, that 
seemed interesting, mentioned problems with kernel 2.6.11.6, 2.6.13 
(using SGI-XFS CVS), but that 2.6.12 (SGI-XFS CVS-2005-06-14_05:00_UTC) 
was working without a problem.

Regards,
Tyler.


-- 
No virus found in this outgoing message.
Checked by AVG Anti-Virus.
Version: 7.0.344 / Virus Database: 267.11.0/103 - Release Date: 9/15/2005

