From: Patrik Jonsson <patrik@ucolick.org>
Subject: Smart and SATA with FC4
Date: Thu, 16 Jun 2005 09:29:31 -0700
Message-ID: <42B1A8EB.6060805@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I just installed a machine running Fedora Core 4 x86_64
(2.6.11-1.1369_FC4 kernel) and I'd like to get smartmontools to work
with my 8-drive SATA array. According to the smartmontools web page and 
previous emails in this list you have to patch
the kernel, so I got the patch called "2.6.11-libata-dev1.patch.gz"
from the libata-dev patchset web page and I'm trying to apply it, but
the patching fails and even after I (think) that I've manually resolved
the problems, the kernel won't compile.

Can some kind soul outline the sequence of events necessary to patch the
kernel and get it to work? I've tried both smartmontools 5.32 and 5.33.
Is one or the other necessary? Or maybe the problem is the FC4 kernel, 
which already has a bunch of patches applied?

Thanks,

/Patrik Jonsson


