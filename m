From: Claas Hilbrecht <claas+maillinglists.linux-raid@jucs-kramkiste.de>
Subject: Re: How to recover a multiple raid5 disk failure with mdadm?
Date: Thu, 11 Aug 2005 16:00:13 +0200
Message-ID: <C3753EFE5DB4D12C7042DF54@[192.168.1.22]>
References: <D3BE8E19A516A6F7F3B10332@[192.168.1.22]>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D3BE8E19A516A6F7F3B10332@[192.168.1.22]>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Am Montag, 8. August 2005 09:18 +0200 Claas Hilbrecht 
<claas+maillinglists.linux-raid@jucs-kramkiste.de> schrieb:

> The output below is from mdadm-2.0-devel-2 examine. What I don't
> understand is that there is difference in the "Spare Devices".

Today I thought I could give the broken raid another try and use 
mdadm-2.0-devel-3. After looking again on the output of mdadm -E /dev/hde1 
I think I had to repair this by hand. The

      Number   Major   Minor   RaidDevice State
this     3      33        1        3      active sync   /dev/hde1

   0     0       0        0    524288      spare
   1 3670016   65536    65536    393216      spare
   2     0       0    131072    589824      spare
   3 2162688   65536    196608    393216      spare
   4 3735552   65536    262144        0      spare

is totaly wrong. I think this is caused due to the bad checksum message in 
the mdadm -E output. Is there any way to fix this information with a disk 
editor or mdadm itself?

-- 
 Claas Hilbrecht
 http://www.jucs-kramkiste.de

