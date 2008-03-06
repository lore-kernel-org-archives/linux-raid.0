From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Subject: Re: RAID-5 data corruption
Date: Thu, 06 Mar 2008 13:01:53 +0100
Message-ID: <47CFDD31.30103@student.tuwien.ac.at>
References: <47CF2B62.7070806@student.tuwien.ac.at> <e9c3a7c20803051711y56500b89n3c3c9984d4607b9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20803051711y56500b89n3c3c9984d4607b9b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dan Williams schrieb:
> 
> Did one of the disks cause the USB reset message?  It appears to
> coincide with the start of the trouble, but it may be just that,
> coincidence.

That's interesting. 5.3.2 is sde, the disk I have to remove to make 
e2fsck run through. I got these messages before, and they never seemed 
to hurt, so I ignored them. mismatch_cnt was always 0, and there's 
another USB disk, which isn't in the RAID, which also shows these resets 
sometimes, and there are no problems with this one.
I do have other USB problems on this machine, though. It has 3 ports, 
and when I set the whole thing up with 2.6.23, two of them weren't 
working correctly (they sometimes disconnected randomly). I thought they 
had just died and since the third worked, I just threw a hub in and went on.
It's of course still possible that it's a hardware issue, but back when 
I used this laptop as my main machine, I never had any USB problems. It 
definitely worked in Windows, I don't remember if I ever used a USB disk 
in Linux on this machine. I'll re-check Windows to see if I have the 
same problem there.
What's interesting as well is that I just re-checked the supposedly bad 
USB ports with 2.6.24 by connecting a disk to each one and reading some 
large files, and I only saw the disconnect issue once today. I couldn't 
reproduce it up to now. That's strange, I remember it being very 
consistent in 2.6.23. I'll check that again too.

> Have you run this operation on a kernel version prior to 2.6.24.3? If
> so, which version?

Which operation do you mean? The array? I started out using 2.6.23.1, 
later switched to 2.6.23.14, then 2.6.24, and recently 2.6.24.3.

-- 
Oliver
