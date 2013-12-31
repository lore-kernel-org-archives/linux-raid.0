From: Pieter De Wit <pieter@insync.za.net>
Subject: Re: Is partition alignment needed for RAID partitions ?
Date: Tue, 31 Dec 2013 14:05:15 +1300
Message-ID: <52C2184B.5030403@insync.za.net>
References: <52C08E63.8020800@insync.za.net> <52C11929.3070600@hardwarefreak.com> <52C12F8B.6080507@insync.za.net> <52C14FB8.8080005@hardwarefreak.com> <52C162A7.1080309@insync.za.net> <52C1A8F0.2030208@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C1A8F0.2030208@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Stan,
> You're welcome.  Eventually you get to the bottom of this.
>
I think this moment has arrived :)

I did some fio tests from all levels, raw disk, raw md device, raw LV, 
filesystem (ext4) on top of LV. All read and write tests came back with 
+- 120MB/s (mostly 128, but let's tone it down just for stats)

I did a read,write and mixed test against the NAS:

The read and write tests came back at 60MB/s, the mixed came in at 11MB/s.

I ran a network test from my desktop to the server, using iperf and it 
got up to 80MB/s, add to that the sync traffic of 10-15MB and you have a 
pretty full gig pipe. The desktop nic is a crappy onboard one, so I am 
quite happy with those stats. Just "FYI" - they are all linked with a 
Cisco 3750G, the NAS has 2xgig ports in an etherchannel

This leaves me only two conclusions:

1) pvmove isn't as fast as I think - it might be due to some checksums 
or some other process (I know it creates a small mirror of a PE and then 
breaks it - rinse repeat for all PEs)
2) That is just the limit for this system, "it is what it is"

Either way - I think I have taken up enough of the list time, so thank 
you very much for the in-depth answers ! I still have access to the NAS 
until at least 13/01/2014 if you want to do more checks/tests.

Have a good 2014!

Cheers,

Pieter
