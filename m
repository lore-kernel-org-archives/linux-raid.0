From: "Yogesh Pahilwan" <pahilwan.yogesh@spsoftindia.com>
Subject: raw I/O support for Fedora Core 4
Date: Thu, 23 Mar 2006 14:54:25 +0530
Message-ID: <WM57DB3DF98115400697C908A54A80DEE9@spsoftindia.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I want to do raw I/O on MD RAID and LVM for fedora core 4(kernel 2.6.15.6).

After doing googling I came to know that "raw" command does the raw
operation by linking 
MD device and LVM volume to the raw device as 

# raw /dev/raw/raw1 /dev/md0.

But when I search on this I came to know that there is no raw (/dev/rawctl)
device support available with 2.6 kernel.
I have also tried recompile the kernel sources with raw device support it is
not getting compiled as it is obsolete in 2.6. 
If I want to include raw device support in my kernel what should I will have
to do, so that I 
Will be able to do raw I/O on MD device and LVM volumes.

Thanks and Regards,
Yogesh

