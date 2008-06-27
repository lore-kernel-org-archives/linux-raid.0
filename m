From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Storing array run-time options in mdadm.conf
Date: Fri, 27 Jun 2008 10:03:15 +0200
Message-ID: <48649EC3.5030607@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

Are there some plans (or an existing mechanism I am not aware of) to store 
array/component related /sys settings? As far as I can tell there is no such 
facility in place and and various distributions/admins are left with the task 
of writing incompatible hack scripts and whatnot. Would it be practical to add 
an extra field to mdadm.conf, which would look like:

ARRAY /dev/mdX .... options=stripe_cache_size:8192,comp_queue_depth:1

Which would mean that the stripe_cache_size ought to be set to 8192 and NCQ 
disabled on all underlying components. It doesn't even have to be the mdadm 
executable which would process and apply these settings. It might still be a 
distro-specific init script or whatnot. The important part is that the 
configuration placement is now standardized and can be built upon.

Maybe this has been discussed before, my apologies for not looking through the 
archives well enough.

Thanks

Peter
