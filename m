From: Jeff Woods <Kazrak+kernel@cesmail.net>
Subject: ICH7R "strip" size
Date: Wed, 26 Jul 2006 20:12:23 -0600
Message-ID: <7.0.1.0.2.20060726194627.06340898@jeffwoods.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Howdy.

I realize this list is more focused on Linux software RAID than 
"proprietary" RAID controllers, but I've been Googling and can't find 
an answer that I suspect someone on this list probably knows. If 
anyone can suggest a better forum for this question or someplace 
where the answer is documented, that would be great.

Intel's ICH7R firmware allows creating volumes in various RAID modes 
where the "strip size" (which I believe to be a misspelling of 
"stripe size") can be certain multiples of 16KB.

IIUC, a RAID "stripe" is composed of "chunks" spanning two or more 
drives. For example, a four disc RAID-5 array with 64KB chunks would 
yield a 256KB stripe with 192KB of usable storage per stripe.

I'm trying to optimize I/O performance for a database with 64KB 
blocks. I understand that RAID-0 multiplies the likelihood of a 
failure but that's only a nuisance and not a problem in my situation.

My question: What are the chunk and usable storage sizes per stripe 
for four discs in RAID-0 on an ICH7R configured for a 128KB "strip"?

Thank you very much.

--
Jeff Woods <kazrak+kernel@cesmail.net> 

