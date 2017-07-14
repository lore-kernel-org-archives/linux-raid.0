From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Filesystem corruption on RAID1
Date: Fri, 14 Jul 2017 02:32:19 +0200
Message-ID: <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 14.07.2017 um 00:34 schrieb Gionatan Danti:
> Il 13-07-2017 23:34 Reindl Harald ha scritto:
>> maybe because the disk is, well, not in a good shape and don't know
>> that by itself
> 
> But the kernel *does* know that, as the dmesg entries clearly show. 
> Basically, some SATA commands timed-out and/or were aborted. As the 
> kernel reported these erros in dmesg, why do not use these information 
> to stop a failing disk?

because you won't be that happy when the kernel spits out a disk each 
time a random SATA command times out - the 4 RAID10 disks on my 
workstation are from 2011 and showed them too several times in the past 
while they are just fine

here you go:
http://strugglers.net/~andy/blog/2015/11/09/linux-software-raid-and-drive-timeouts/
