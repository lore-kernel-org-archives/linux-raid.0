From: "Ryan P. Joseph" <rjoseph@jaw.lanl.gov>
Subject: Faulty disk detection code: looking to tweak it for network devices
Date: Mon, 4 Aug 2003 16:27:44 -0600 (MDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0308041612440.965-100000@jaw.lanl.gov>
Reply-To: rjoseph@kerr.lanl.gov
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

My group here at LANL is attemping to create commodity distributed disk arrays
with open source software to achieve good price/performance ratios.  To that
end, we use the network block device (NBD) in linux for our network transport.
Yes, we've looked pretty deeply into ENBD but for various reasons (namely it's
"intelligent RAID" is only RAID-1) it didn't fit the bill.

However, we've run into a problem: our cluster (space-simulator.lanl.gov) is
our test-bed (because each node has a basically unused hard disk), and it is
under constant use (as you would expect, it's a simulation machine).

Because of the use on the Space Simulator, network congestion is quite common,
and when the network gets congested, if any of the node's NBD devices are in a
running RAID array, that disk is immediatley marked as failed and the RAID
array goes into degraded mode.

This is quite a problem when it comes to fairly large (1-2TB) arrays, because
the time required to resync them over the network is tremendous and places a
heavy load on the switch, slowing the entire cluster down.

What I'd *like* to do (yes, I know about ENBD's "intelligent" RAID and the
"fr" fast RAID device, but both only allow RAID-1, which is completley against
the point of providing a very large disk array as we loose a huge amount of
disk space using it) is to locate - in the kernel RAID drivers - where a disk
is marked as faulty and add some network-intelligent code that would basically
just hold off marking that disk faulty for a specified period of time, as 95%
of the time the network will "fix itself" and the NBD device will come back.

I've managed to track down the faulty disk detection to raid5.c,
raid5_end_read_request() and raid5_end_write_request() (I'm really only
interested in RAID-5 at the moment).  However, all I can really tell is that
these methods get called quite a bit, and when the device "fails", the call
md_error() to make this known.

So, my real question is: where in the blazes does the MD/RAID system actually,
really, seriously detect a failed disk?!  And when it does this, what is the
path of function calls taken to say "hey, this disk is failed, don't use it!"?

Thanks for the help!
Ryan Joseph

-- 
Ryan P. Joseph                    T-6 Theoretical Astrophysics
rjoseph@lanl.gov                        TA 3, SM 123 - MS B227
505-664-0830                    Los Alamos National Laboratory

