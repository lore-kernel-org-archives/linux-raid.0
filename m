From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: Problems with software RAID + iSCSI or GNBD
Date: Wed, 29 Jun 2005 12:09:45 +1000
Message-ID: <42C202E9.40504@nighthawkrad.net>
References: <42BF67A2.6040601@nighthawkrad.net> <42C17540.3000709@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42C17540.3000709@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: mjstumpf@pobox.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Stumpf wrote:
> I probably can't help much at the moment, but...
> 
> I didn't realize that NBD type things had advanced to even this level of 
> stability.  This is good news.  I've been wanting to do something like 
> what you're trying for some time to overcome the bounds of  
> power/busses/heat/space that limit you to a single machine when building 
> a large md or LVM.  Looking at the GNBD project page, it still seems 
> pretty raw, although a related project DDRAID seems to hold some promise.
> 
> I'd be pretty timid about putting anything close to production on these 
> drivers, though.
> 
> What distro / kernel version / level of GNBD are you using?

Well, I don't know if they have yet - the main reason I'm fiddling with 
this is to see if it's feasible :).

However, I have belted tens of gigabytes of data at the mirror-over-GNBD 
and mirror-over-iSCSI using various benchmarking tools without any 
kernel panics or (apparent) data corruption, so I'm gaining confidence 
that it's a workable solution.  I haven't yet started the same level of 
testing with Windows and Linux clients sitting above the 
initiator/bridge level yet, however, as I want to make sure the back end 
is pretty stable before moving on (as it will become a - relatively - 
single point of failure for most of the important machines in our 
network, and hence the entire company).

I'm just using a stock Fedora Core 4 and the GNBD it includes.  A bit 
bleeding edge, I know, but I figured since it had just been released 
when I started on this project, why not ;).

With regards to the problem I was having with node failures, at least 
with iSCSI the solution was setting a timeout so that a "disk failed" 
error was actually returned - by default the iSCSI initiator assumes any 
disconnection errors are network-related and transient, so it simply 
stops any IO to the iSCSI target until it reappears.  Now that I've 
specified a timeout, node "failures" behave as expected and the mirror 
goes into degraded mode.

I assume I need to do something similar with GNBD so that it really does 
"fail", rather than "hang", but I've been too busy over the last few 
days to actually look into it.

CS
