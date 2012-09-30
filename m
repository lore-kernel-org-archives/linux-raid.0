From: Chris Murphy <lists@colorremedies.com>
Subject: Re: mdadm --grow Hard Drive Size Puzzle
Date: Sat, 29 Sep 2012 20:48:24 -0600
Message-ID: <A8856D84-CF03-41CF-A465-076B588B0E44@colorremedies.com>
References: <67FBE301-6EF3-4B0D-87FC-8A3C66473416@thinkcomputer.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <67FBE301-6EF3-4B0D-87FC-8A3C66473416@thinkcomputer.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 29, 2012, at 8:19 PM, Aaron Greenspan wrote:

> md2 : active raid1 sdb3[3] sda3[2]
>      1020115 blocks super 1.2 [2/2] [UU]
> 
> md3 : active raid1 sdb5[2] sda5[3]
>      865593721 blocks super 1.1 [2/2] [UU]
> 
> md1 : active raid1 sdb2[2] sda2[3]
>      221182844 blocks super 1.1 [2/2] [UU]
>      bitmap: 0/2 pages [0KB], 65536KB chunk
> 
> md0 : active raid1 sdb1[2] sda1[3]
>      102388 blocks super 1.0 [2/2] [UU]

I'm curious why three different versions of md metadata are being used. Did you use dd to copy the data over, or how? Were you booted off a LiveCD or some other disk when doing the copying, or how? Can you supply the results from fdisk -l ?

Chris Murphy

