From: Tara Piorkowski <tara@vilaj.com>
Subject: Kernel config for auto detect and boot support
Date: Mon, 12 Aug 2002 15:19:30 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D580A42.7050104@vilaj.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I need to get RAID-1 running on one of our servers we use with a hosting 
service (thus, I don't have physical access to the machine). I have done 
lots of reading and just wanted to verify that my understanding of 
things is correct as not being able to bring the machine back online in 
case of a problem would not be a good thing. I have two questions...

1) I have found various references to setting "auto detect" and "boot 
support" options during the kernel configuration process. Since I want 
to boot from a RAID partition, I obviously need this support. However, I 
have been unable to find these options in the 2.4.18 configuration 
process. Thus, I assume that at some point in the 2.4.x series this 
support has been rolled into  the broader "RAID support" option, right? 
(I built my kernel with just that and the RAID-1 options.)

2) In the interest of reliability, I wish to RAID my swap partitions as 
well. My understanding of this is that I should simply create partitions 
of type 0xFD on my two drives, initialize the RAID, mkswap on the source 
partition (since the kernel doesn't look at partition type when mounting 
swap), and make the appropriate /etc/fstab entries. Is this correct?

I appreciate any assistance that I receive. Thanks.

                                      Tara

-- 
Tara Piorkowski
System Administrator
vilaj.com, LLC
<http://www.vilaj.com/>

