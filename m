From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Use of WD20EARS with MDADM
Date: Thu, 22 Apr 2010 07:24:57 +1200
Message-ID: <4BCF5109.2000807@sauce.co.nz>
References: <4BAB8D41.4010801@gmail.com> <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com> <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net> <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com> <4BCEFB99.9080806@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCEFB99.9080806@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:

> I'd love to find some real data, anecdotal stories about older drives
> are not overly helpful. Clearly there is a trade-off between energy
> saving, response, and durability, I just don't have any data from a
> large population of new (green) drives.

I can add some very limited, (6 drives) observations on the 2GB RE 
version - WD2002FYPS.

These are green drives and have been running continuously in an md RAID5 
for eight months without any problems and no drive settings have been 
altered. This array is idle except for a nightly rsync session for an 
hour or so.

Looking at the SMART data, load cycle count, is 23862 which sounds like 
a lot, but the current VALUE entry is 193 (and started at 200 8 months 
ago) and the THRESHOLD value is 0.

So, if I am interpreting this trend correctly, the THRESHOLD value will 
be reached in about 682,000 load cycles and about 228 months.

Regards,

Richard


