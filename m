From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 3ware 9650 tips
Date: Sat, 14 Jul 2007 12:18:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707141215200.3534@p34.internal.lan>
References: <240460.11630.qm@web60012.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <240460.11630.qm@web60012.mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Klaassen <clawsoon@yahoo.com>
Cc: Joshua Baker-LePain <jlb17@duke.edu>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 14 Jul 2007, Andrew Klaassen wrote:

> --- Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>> 03:00.0 RAID bus controller: Silicon Image, Inc. SiI
>> 3132 Serial ATA Raid
>> II Controller (rev 01)
>>
>> $19.99 2 port SYBA cards (Silicon Image 3132s)
>>
>> http://www.directron.com/sdsa2pex2ir.html
>
> Cool, thanks.
>
> What are your bonnie++ rewrite numbers?
>
> Andrew

3 runs:
p34,16G,77169,99,413276,80,155348,26,78932,99,535482,41,607.0,0,16:100000:16/64,1500,12,4886,15,1790,16,1821,17,6081,19,2159,19
p34,16G,77659,99,451593,87,167267,28,79058,99,584310,45,613.1,0,16:100000:16/64,1843,15,6006,31,1325,11,1204,12,3629,12,3324,31
p34,16G,77873,99,441881,87,166384,28,75182,99,566384,43,619.4,0,16:100000:16/64,1537,13,4474,15,1827,18,880,8,7658,22,3864,36

avg: 
p34,16G,77567,99,435583,84.6667,163000,27.3333,77724,99,562059,43,613.167,0,16:100000:16/64,1626.67,13.3333,5122,20.3333,1647.33,15,1301.67,12.3333,5789.33,17.6667,3115.67,28.6667

rewrite:
163000 KiB/s

When tarring 4.4GB (of backup files) it takes about 20 seconds on XFS.

Seems to vary as I change my configuration a lot:

Here is from a while back:

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
p34-raid5    15696M 73755  99 411445  75 198639  34 78721  99 483169  39 
584.8   0
                     ------Sequential Create------ --------Random 
Create--------

p34-raid5,15696M,73755,99,411445,75,198639,34,78721,99,483169,39,584.8,0,16:100000:16/64,919,8,9940,28,2841,18,922,8,3225,10,2422,18


Justin.
