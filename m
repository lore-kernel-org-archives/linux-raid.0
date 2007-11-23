From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: md RAID 10 on Linux 2.6.20?
Date: Fri, 23 Nov 2007 13:18:57 -0500
Message-ID: <47471991.2070304@tmr.com>
References: <8C9FB9564550DC0-464-E73@FWM-D05.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8C9FB9564550DC0-464-E73@FWM-D05.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thomas62186218@aol.com wrote:
> Hi all,
>
> I am running a home-grown Linux 2.6.20.11 SMP 64-bit build, and I am 
> wondering if there is indeed a RAID 10 "personality" defined in md 
> that can be implemented using mdadm. If so, is it available in 
> 2.6.20.11, or is it in a later kernel version? In the past, to create 
> RAID 10, I created RAID 1's and a RAID 0, so an 8 drive RAID 10 would 
> actually consist of 5 md devices (four RAID 1's and one RAID 0). But 
> if I could just use RAID 10 natively, and simply create one RAID 10, 
> that would of course be better both in terms of management and 
> probably performance I would guess. Is this possible?

Yes, and you are correct on the performance. Read the man page section 
on "near" and "far" copies of data carefully, and some back posts to 
this list. Most of us find that using far copies generates slightly 
slower write performance and significantly better read performance.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

