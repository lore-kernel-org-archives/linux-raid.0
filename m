From: Tim Small <tim@buttersideup.com>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', homebrew 2.4.25
 kernel
Date: Wed, 04 Aug 2004 11:34:40 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4110BBC0.90203@buttersideup.com>
References: <ceq7ij$vj7$1@sea.gmane.org> <27897.194.60.85.4.1091613610.squirrel@194.60.85.4> <200408041129.44767.m.watts@eris.qinetiq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408041129.44767.m.watts@eris.qinetiq.com>
To: Mark Watts <m.watts@eris.qinetiq.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Watts wrote:

>Talking of partitioning several disks the same, is there an easy way to 
>automate this?
>  
>
Hmm, I gave a way to do this in my last email, but I've realised that I 
missed out the "count" argument to dd...  I said:

> dd if=/dev/hda of=/dev/hdc ; echo w | fdisk /dev/hdc 

This will work, but will take a while ;o)  it should really have been:

dd if=/dev/hda of=/dev/hdc count=1 && echo w | fdisk /dev/hdc



Tim.

