From: Gordon Henderson <gordon@drogon.net>
Subject: Re: partition based raid1 and multi boot Ubuntu/Xubuntu
Date: Thu, 24 Nov 2011 11:54:48 +0000 (GMT)
Message-ID: <alpine.DEB.2.00.1111241105300.17642@unicorn.drogon.net>
References: <4ECC20C4.6050504@alabastercranium.demon.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ECC20C4.6050504@alabastercranium.demon.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 22 Nov 2011, Gavin Whitehead wrote:

> I then installed Ubuntu 11.04 from the Alternate CD and created some raid1 
> devices
>    md0        sda1 sdb1    /
>    md1        sda5 sdb5    swap
>    md2        sda6 sdb6    /home

Can't help you with the GRUB issue as I use LILO, however... Something 
that someone on this list suggested to me many year back has stuck with me 
and proven to be useful and that's to try to number the md devices the 
same as the sd (or hd in those days!) devices, so:

md1 : active raid1  sdb1[1] sda1[0]
md2 : active raid10 sdb2[1] sda2[0]
md3 : active raid10 sdb3[1] sda3[0]
md5 : active raid10 sdb5[1] sda5[0]

etc.

Is it still a good idea? I think so - anything that helps to reduce the 
possibility of mistakes is good in my books...

Gordon
