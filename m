From: Ben Bucksch <linux.news@bucksch.org>
Subject: Re: Use RAID-6!
Date: Wed, 17 Apr 2013 02:20:36 +0200
Message-ID: <516DEAD4.7080305@bucksch.org>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <516DABF2.5050409@tigertech.com> <516DAF21.5040409@aei.mpg.de> <516DD433.50100@tigertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516DD433.50100@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Robert L Mathews wrote, On 17.04.2013 00:44:
> the endless reports of complete array failures that appear on the list 
> with RAID 5 and even RAID 6 (a recent topic, I note, was "multiple 
> disk failures in an md raid6 array"). I almost never see anyone 
> reporting complete loss of a RAID 1 array.

Correct

> The fundamental difference between RAID 1 and other levels seems to be 
> that the usefulness of an individual array member doesn't rely on the 
> state of any other member. This vastly reduces the impact of failures 
> on the overall system. After using mdadm with various RAID levels 
> since 2002 (thanks, Neil), I'm convinced that RAID 1 is by its very 
> nature far less fragile than any other scheme. This belief is sadly 
> reinforced almost every week by a new tale of woe on the mailing list. 

Exactly.

However, I think the RAID5 problems are caused by bad design decisions 
in the md implementation, not in the inherent concept of RAID5, though. 
Many people seem to have problems getting to the data of their RAID5 
array, although they have enough disks that are readable, but they can't 
convince md to read it. RAID1 doesn't have that problem, because you can 
ignore md when reading them. This is a home-made problem of Linux md.

FWIW, my own 10 years of experience with Linux md RAID led to the same 
conclusion as you had.

See thread "md dropping disks too early"

Ben
