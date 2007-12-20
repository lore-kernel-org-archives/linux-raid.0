From: Michal Soltys <soltys@ziu.info>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Thu, 20 Dec 2007 14:01:40 +0100
Message-ID: <476A67B4.3020107@ziu.info>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan>	 <476990B4.5050803@ziu.info> <cccedfc60712191412j27256304p185d6d06e27d9ebe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60712191412j27256304p185d6d06e27d9ebe@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Nelson wrote:
> 
> That, for me, is the next question - how can one educate LVM about the
> underlying block device such that logical volumes carved out of that
> space align properly - many of us have experienced 30% (or so)
> performance losses for the convenience of LVM (and mighty convenient
> it is).
> 

When you do pvcreate you can specify --metadatasize. It will add padding 
just to hit next 64K boundary.

So i.e. if you do

#pvcreate --metadatasize 256K /dev/sda

your metadata will have 320K

but with

#pvcreate --metadatasize 255K /dev/sda

it will have 256K

After that, lvm extents will follow - with the size specified during 
vgcreate. Also I tend to use rather large sized extents (512M), as I 
don't really need the granularity offered by the default 4M.

