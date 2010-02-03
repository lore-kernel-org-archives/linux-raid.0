From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: If your using large Sata drives in raid 5/6 ....
Date: Wed, 3 Feb 2010 11:56:32 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002031154250.31777@uplift.swm.pp.se>
References: <87f94c371002021440o3b30414bk3a7ccf9d2fa9b8af@mail.gmail.com> <87f94c371002021446y38dce6fds6acca2b4919ad773@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c371002021446y38dce6fds6acca2b4919ad773@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2 Feb 2010, Greg Freemyer wrote:

> (I think these drives may already be available at least as engineering 
> samples.  Basic linux kernel support went in summer 2009 I believe. I 
> believe 2.6.33 will be the first kernel to have been tested with these 
> new class of drives.)

I purchased two WD20EARS drives yesterday, going to play around with them 
tonight. They emulate 512 bytes sectors to the SATA layer but write them 
as 4k on drive, so you want to make sure that everything that writes to 
the drive, writes in 4k block size (which is the case with most in linux 
as far as I have understood).

So basically they'll work with any OS, but for best performance you need 
to make sure that things are aligned to 4k boundary and you want to write 
4k at a time.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
