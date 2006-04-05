From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Can't mount /dev/md0 after stopping a synchronization
Date: Wed, 05 Apr 2006 13:24:44 -0400
Message-ID: <4433FD5C.1050109@steeleye.com>
References: <c79e949d0604042045w2fb901c2rfb4c00984f6b8761@mail.gmail.com>	 <4433E073.8040502@fnuck.dk> <c79e949d0604050839k2287fefdm53f6abb08dfcae89@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c79e949d0604050839k2287fefdm53f6abb08dfcae89@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Garey <random51k@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mike Garey wrote:

> I seem to be getting closer.. If I try booting from a kernel without
> raid1 and md support, but using an initrd with raid1/md modules, then
> I get the "ALERT! /dev/md0 does not exist.  Dropping to a shell!"
> message.  I can't understand why there would be any difference between
> using a kernel with raid1/md support, or using an initrd image with
> raid1/md support, but apparently there is.  If anyone else has any

Autodetection doesn't occur unless md is built into the kernel -- one of 
the reasons why using autodetection is becoming less and less popular. 
You're probably better off assembling the array from your initrd with 
some invocation of mdadm.

--
Paul
