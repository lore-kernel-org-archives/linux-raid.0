From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: readahead (blockdev --setra) with sw raid(5)?
Date: Sun, 28 Nov 2004 11:46:36 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411281144440.17548@adsl.a2000.nu>
References: <Pine.LNX.4.61.0411272328270.16979@adsl.a2000.nu>
 <41A9133D.5000809@dgreaves.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41A9133D.5000809@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 27 Nov 2004, David Greaves wrote:

> I routinely use --setra 4096 on the underlying devices, the md array devices 
> and the lvm devices
> I am generally reading 1-2 gigabyte files.
>
> I use XFS and it is often suggested as a good fs (though I think there may be 
> some XFS/nfs issues with 2.6 at the moment - see lkml)
>

ok i'll try 4096 then on my devices
(why did you choose 4096 and not 2048 (or 8192 (or bigger?)

also i think i'll create my new raid5 with xfs
are there any special tuning options i can use with xfs ? (like stride 
with ext3)

i think i'll go with 256 stripe size (not sure if i want to go 512)
