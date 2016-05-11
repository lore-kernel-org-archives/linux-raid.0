From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid 5 crashed
Date: Wed, 11 May 2016 14:09:09 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1605111406530.28372@uplift.swm.pp.se>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: bobzer <bobzer@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 10 May 2016, bobzer wrote:

> PLEASE help me :-) i don't know what to do so i did nothing to not do 
> any stupid things 1000 thank you

What does dmesg say? Did you get read error on one of the remaining 3 
drives? Then you need to look into the archives to use dd_rescue to get as 
much data off of that drive as possible, and try again.

It would also help if you provided what kernel version and mdadm version 
you're using.

Before you try again, also do this:

for x in /sys/block/sd[a-z] ; do
         echo 180  > $x/device/timeout
done

This makes sure the kernel will not kick a drive that might take long to 
respond due to read errors.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
