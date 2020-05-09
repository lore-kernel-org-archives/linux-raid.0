From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: Assemblin journaled array fails
Date: Sun, 10 May 2020 01:57:47 +0200
Message-ID: <70dad446-7d38-fd10-130f-c23797165a21@yandex.pl>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Anyway, I did some tests with manually snapshotted component devices 
(using dm snapshot target to not touch underlying devices).

The raid manages to force assemble in read-only mode with missing 
journal device, so we probably will be able to recover most data 
underneath this way (as a last resort).

The situation I'm in now is likely from uncelan shutdown after all (why 
the machine failed to react to ups properly is another subject).

I'd still want to find out why is - apparently - a journal device giving 
issues (contrary to what I'd expect it to do ...), with notable mention of:

1) mdadm hangs (unkillable, so I presume in kernel somewhere) and eats 1 
cpu when trying to assemble the raid with journal device present; once 
it happens I can't do anything with the array (stop, run, etc.) and can 
only reboot the server to "fix" that

2) mdadm -D shows nonsensical device size after assembly attempt (Used 
Dev Size : 18446744073709551615)

3) the journal device (which itself is md raid1 consisting of 2 ssds) 
assembles, checks (0 mismatch_cnt) fine - and overall looks ok.


 From other interesting things, I also attempted to assemble the raid 
with snapshotted journal. From what I can see it does attempt to do 
something, judging from:

dmsetup status:

snap_jo2: 0 536870912 snapshot 40/33554432 16
snap_sdi1: 0 7812500000 snapshot 25768/83886080 112
snap_jo1: 0 536870912 snapshot 40/33554432 16
snap_sdg1: 0 7812500000 snapshot 25456/83886080 112
snap_sdj1: 0 7812500000 snapshot 25928/83886080 112
snap_sdh1: 0 7812500000 snapshot 25352/83886080 112

But it doesn't move from those values (with mdadm doing nothing eating 
100% cpu as mentioned earlier).


Any suggestions how to proceed would very be appreciated.
