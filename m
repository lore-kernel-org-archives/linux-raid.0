From: James Braid <jamesb@loreland.org>
Subject: chunk size must be power of two?
Date: Wed, 06 Dec 2006 21:29:06 +0000
Message-ID: <45773622.8020704@loreland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is there any reason the chunk size has to be a power of two?

We're trying to use md devices to stripe over hardware RAID5 arrays, so 
to align the I/O correctly, I want to set the chunk size to (n - 1) * 
stripe_size for the underlying array. Which is impossible to do because 
mdadm (and the kernel) insist on the chunk size being a power of two.

I haven't tried just removing the kernel checks yet ... is there a 
reason why md is limited to power of two chunk sizes?

Failing that, does anyone know of anything else I can use to stripe 
block devices together which doesn't have the power of two limitation? 
device-mapper/LVM seems to have the same problem...
