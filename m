From: Jan Wagner <jwagner@kurp.hut.fi>
Subject: 32-bit sys/times.h incorrect return value
Date: Thu, 13 Aug 2009 12:10:27 +0300 (EEST)
Message-ID: <alpine.DEB.2.00.0908131141330.24630@orbit.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

we see times() return a really large positive value like 0x66693CF1 i.e. 
signed int32 +1718172913 just a few minutes after booting.

Note that clock_gettime(CLOCK_MONOTONIC) works correctly and returns the 
uptime. While times() +1718172913/100Hz time is in no relation to uptime.

Checking 'man 2 times': "Since Linux 2.6, this point is (2^32/HZ) - 300 
(i.e., about 429 million) seconds before system boot time. [...] the 
returned value may overflow the range of clock_t [...]"

Hence in theory on a 32-bit platform where clock_t is signed 32-bit, at 
first times() should return negative values.

Then 300 seconds later they should become positive. Correct?

This should also happen via glibc times() call. There the times()
   ./sysdeps/unix/sysv/linux/times.c
simply does
   clock_t ret = INTERNAL_SYSCALL (times, err, 1, buf);
with no extra "+- some constant".

In the kernel all jiffies and times syscall related handling is 64-bit:

---------
amn@multics:/home/etu/Desktop/linux-2.6.30.3/include$ fgrep INITIAL_JIFFIES
linux/jiffies.h:#define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))

kernel/sys.c:   return (long) jiffies_64_to_clock_t(get_jiffies_64());

kernel/time.c:u64 get_jiffies_64(void)
kernel/time.c:          ret = jiffies_64;
---------

On 32-bit platforms and signed int32 clock_t it should take at least

octave:1>  2^31/(24*60*60 * 100)
ans =  248.55
octave:2>  (2^31/100 - 300)/(24*60*60)
ans =  248.55

days until the positive times() return value wraps back to smallest 
negative signed 32-bit int.

However, two bugs(?) :

1) times() return value after 1080 'uptime' seconds is 0x66693CF1, why?

Expected value would be (1080-300)*100Hz = 78000 = 0x000130B0 !

2) the times() wraps to negative only after 50 days uptime. Following the 
intention of INITIAL_JIFFIES, how is this 50-day warp supposed to reveal 
wrapping bugs right at 300 seconds after boot?

2) on 64-bit platforms, clock_t is 64-bit. There times() does not wrap 
after 50 days, however it still starts at 0x000000006669**** !?


Any ideas?

  - Jan
