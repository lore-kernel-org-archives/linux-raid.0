From: David Greaves <david@dgreaves.com>
Subject: Re: linear raid space utilization
Date: Sat, 21 Jan 2006 08:48:08 +0000
Message-ID: <43D1F548.6020407@dgreaves.com>
References: <cc5782160601202312y25bc339cvcb1973c24208da3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cc5782160601202312y25bc339cvcb1973c24208da3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Gajetzki <andy.gajetzki@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andy Gajetzki wrote:

>Hi there,  I recently had a disk go bad in a linear RAID built with
>mdadm. The particular disk that failed was the last  device of the
>RAID. I am curious about how  devices are utilized in a linear RAID.
>Would the md be filled sequentially from device 1 upto 5? In other
>words, what are the odds that the last disk was "empty" when it went
>south?
>
>Thanks for your time,
>  
>
Linear raid does provide sequential blocks on disks 1...n

So as long as the filesystem you used was something like 'dd
of=/dev/md0' then you'd be OK <grin>

However if you made a 'proper' filesystem on it then the disk usage
would vary depending on whether it was ext2,ext3,xfs,jfs etc etc

If the bad disk is totally gone then you're at the mercy of fs deign and
fsck - otherwise try and use ddrescue to get an image of it (and the
other disks). Make a 'safe' image and a 'working' image of the bad disk
before attempting repair on 'working' images.
(Of course you need lots of disk space so you may need new disks -
depends how valuable your data is)

HTH

David

-- 

