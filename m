From: Jeff Hanson <jhanson@sgi.com>
Subject: Re: mdadm 2.0 and 2.1 compile error
Date: Wed, 28 Sep 2005 09:46:01 -0400
Message-ID: <pan.2005.09.28.13.45.57.358668@sgi.com>
References: <Pine.LNX.4.63.0509262217180.24352@adsl.a2000.nu> <17208.63983.493938.764444@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 27 Sep 2005 09:51:11 +0200, Neil Brown wrote:

> On Monday September 26, raid@a2000.nu wrote:
>> I am trying to compile mdadm 2.x (currently running version 1.12)
>> 
>> On "make" I get the following fatal error for both 2.0 and 2.1:
>> 
>> In file included from super0.c:31:
>> /usr/include/asm/byteorder.h:6:2: #warning using private kernel header; 
>> include <endian.h> instead!
>> make: *** [super0.o] Error 1
>> 
>> any idea ?
> 
> This means your distro is crazy.  endian.h does not contain the
> defines that I need from byteorder.h.
> Just remove the '-Werror' from the Makefile and try again.

That resolved it for me.  Distro is RHEL 4 in my testing.
-- 
-----------------------------------------------------------------------
Jeff Hanson - jhanson@sgi.com - Field Technical Analyst

You can choose a ready guide in some celestial voice. 
If you choose not to decide, you still have made a choice. 
You can choose from phantom fears and kindness that can kill; 
I will choose a path that's clear 
I will choose freewill. - Lee/Lifeson/Peart


