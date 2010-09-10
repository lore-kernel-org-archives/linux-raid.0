From: Drew <drew.kay@gmail.com>
Subject: cpu_relax() usage in raid6algos.c
Date: Thu, 9 Sep 2010 18:55:12 -0700
Message-ID: <AANLkTim6qQyhh4S0mOYoh5XPp8Zu1dj5gm2BU4zi2UpE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I was going through the raid6 code in 2.6.35 and I came across an
empty function definition for cpu_relax() in include/linux/raid/pq.h
(line 135) that appears to be called in drivers/md/raid6algos.c (line
113). My C code skills are a bit rusty but I'm assuming the
cpu_relax() call in raid6algos.c uses the definition in pq.h.

If so, why is cpu_relax() in pq.h an empty function when there's
already a definition for cpu_relax() in
arch/x86/include/asm/processor.h?

Conversely, if the cpu_relax() function call in raid6algos.c uses the
definition in processor.h, why do we have a second definition in pq.h?

It strikes me that if the purpose of cpu_relax() is to signal the
kernel that we're not doing anything, why create our own empty
function when there's already one that is correct across all supported
architectures?

-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
