From: Wolfgang Denk <wd@denx.de>
Subject: Re: raid6check extremely slow ?
Date: Mon, 11 May 2020 08:33:42 +0200
Message-ID: <20200511063342.1D483240E1A@gemini.denx.de>
References: <20200510120725.20947240E1A@gemini.denx.de> <20200510132611.GA12994@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20200510132611.GA12994@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Piergiorgio,

In message <20200510132611.GA12994@lazy.lzy> you wrote:
>
> raid6check is CPU bounded, no vector optimization
> and no multithread.
>
> Nevertheless, if you see no CPU load (single core
> load), then something else is not OK, but I've no
> idea what it could be.
>
> Please check if one core is up 100%, if this is
> the case, then there is the limit.
> If not, sorry, I cannot help.

No, there is virtually no CPU load at all:

top - 08:32:36 up 8 days, 16:34,  3 users,  load average: 1.00, 1.01, 1.00
Tasks: 243 total,   1 running, 242 sleeping,   0 stopped,   0 zombie
%Cpu0  :  0.0 us,  0.0 sy,  0.0 ni, 98.7 id,  0.0 wa,  1.3 hi,  0.0 si,  0.0 st
%Cpu1  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu2  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu3  :  0.3 us,  1.3 sy,  0.0 ni, 97.7 id,  0.0 wa,  0.3 hi,  0.3 si,  0.0 st
%Cpu4  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu5  :  1.7 us,  3.7 sy,  0.0 ni, 90.4 id,  3.0 wa,  0.7 hi,  0.7 si,  0.0 st
%Cpu6  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
%Cpu7  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :  24034.6 total,  10921.2 free,   1882.4 used,  11230.9 buff/cache
MiB Swap:   7828.5 total,   7828.5 free,      0.0 used.  21757.0 avail Mem

What I find interesting is thet all disks are more or less
constantly at around 400 kB/s (390...400, never more).

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
That's their goal, remember, a goal that's really contrary to that of
the programmer or administrator. We just want to get our  jobs  done.
$Bill  just  wants  to  become  $$Bill. These aren't even marginallly
congruent.
         -- Tom Christiansen in <6jhtqk$qls$1@csnews.cs.colorado.edu>
