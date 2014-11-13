From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Re: md with shared disks
Date: Thu, 13 Nov 2014 23:53:21 +0100
Message-ID: <54653661.80605@shiftmail.org>
References: <545F2630.8090307@true.co.za> <546138B5.7020101@hardwarefreak.com> <5464AEA8.3010106@true.co.za> <54651B05.1050104@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54651B05.1050104@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/11/2014 21:56, Stan Hoeppner wrote:
> With DRBD and GFS2 it is true active/active at the block level.  You
> just lose half your disk capacity due to the host-to-host mirroring.

Sorry but I don't share your definition of active/active.

Would you say that a raid1 is an active/active thing?

Doubling the number of disks and repeating the operation on both sides 
is not active/active in the sense that people usually want.

Active/active commonly means that you have twice the performance of 
active/passive.

In this sense DRBD not only is an active/passive but it is even way 
below the performances of an active/passive because it has to transmit 
the data to the peer in addition to write to the disks, and this takes 
CPU time for memcpy and interrupts, introduces latency, requires 
additional hardware (= fast networking dedicated to DRBD). An 
active/passive with shared disks is hence "twice" (very roughly) faster 
than DRBD at the same price spent on the head nodes. An active/active 
with shared disks is hence 4 times (again very roughly) faster than 
DRBD, at the same price for the head nodes.

In addition to this with DRBD you have to buy twice the number of disks, 
which is also an additional expense. Marginally though, because a 
shared-disk infrastructure is way more expensive than a direct-attached 
one, but it has to be planned like that in advance, and not retrofitted 
like you propose.

His current infrastructure cannot be easily converted to DRBD without 
major losses: if he attempts to do so he will have almost double the 
costs of a basic DRBD shared-nothing direct-attached infrastructure or 
exactly double the cost of a shared-disk infrastructure, intended as 
cost per TB of data. Unfortunately, after this he will still have half 
the performances of an active/passive shared-disk clustered-MD solution.

