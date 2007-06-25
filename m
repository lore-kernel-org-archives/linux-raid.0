From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: stripe_cache_size and performance
Date: Mon, 25 Jun 2007 17:12:08 -0500 (CDT)
Message-ID: <Pine.LNX.4.64.0706251705040.5806@gheavc.wnzcbav.cig>
References: <Pine.LNX.4.64.0706211312480.5806@gheavc.wnzcbav.cig>
 <5d96567b0706211242p7f03bd1cw9102ae3e44d67cee@mail.gmail.com>
 <Pine.LNX.4.64.0706211808140.5806@gheavc.wnzcbav.cig>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706211808140.5806@gheavc.wnzcbav.cig>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 21 Jun 2007, Jon Nelson wrote:

> On Thu, 21 Jun 2007, Raz wrote:
> 
> > What is your raid configuration ?
> > Please note that the stripe_cache_size is acting as a bottle neck in some
> > cases.

Well, that's kind of the point of my email. I'll try to restate things, 
as my question appears to have gotten lost.

1. I have a 3x component raid5, ~314G per component. Each component 
happens to be the 4th partition of a 320G SATA drive. Each drive 
can sustain approx. 70MB/s reads/writes. Except for the first 
drive, none of the other partitions are used for anything else at this 
time. The system is nominally quiescent during these tests.

2. The kernel is 2.6.18.8-0.3-default on x86_64 (openSUSE 10.2).

3. My best sustained write performance comes with a stripe_cache_size of 
4096. Larger than that seems to reduce performance, although only very 
slightly.

4. At values below 4096, the absolute write performance is less than the 
best, but only marginally. 

5. HOWEVER, at any value *above* 512 the 'check' performance is REALLY 
BAD. By 'check' performance I mean the value displayed by /proc/mdstat 
after I issue:

echo check > /sys/block/md0/md/sync_action

When I say "REALLY BAD" I mean < 3MB/s. 

6. Here is a short incomplete table of stripe_cache_size to 'check' 
performance:

384.... 72-73MB/s
512.... 72-73MB/s
640.... 73-74MB/s
768.....3-3.4MB/s

And the performance stays "bad" as I increase the stripe_cache_size.

7. And now, the question: the best absolute 'write' performance comes 
with a stripe_cache_size value of 4096 (for my setup). However, any 
value of stripe_cache_size above 384 really, really hurts 'check' (and 
rebuild, one can assume) performance.  Why?

--
Jon Nelson <jnelson-linux-raid@jamponi.net>
