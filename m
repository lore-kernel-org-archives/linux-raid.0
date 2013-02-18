From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: problems formatting raid5
Date: Mon, 18 Feb 2013 09:17:01 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302180915080.32644@uplift.swm.pp.se>
References: <1361174312.47911.YahooMailNeo@web163006.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1361174312.47911.YahooMailNeo@web163006.mail.bf1.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: sk <sdk0084@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 17 Feb 2013, sk wrote:

> Hi There,
>
> I am trying to create file system on a software raid5 device but after while it hangs on:
>
> Writing superblocks and filesystem accounting information:
>
> i have tried with mkfs.ext4, and mke2fs as well but the result was the same.
> any ideas what could be wrong ?

"iostat -x 5", check if there is activity going on. Start it before you do 
the mkfs to make sure nothing is going on (for instance a resync) before 
you start creating the filesystem.

A large filesystem with ext3/ext4 takes quite a while to create. How long 
did you wait until you decided it was "hung" ?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
