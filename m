From: Ric Wheeler <ric@emc.com>
Subject: Re: Accelerating Linux software raid
Date: Sat, 10 Sep 2005 08:58:10 -0400
Message-ID: <4322D862.3000300@emc.com>
References: <Pine.LNX.4.44.0509100033570.29141-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0509100033570.29141-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Dan Williams <dan.j.williams@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:

>>hardware.  I/O processors like the Intel IOP333
>>(http://www.intel.com/design/iio/docs/iop333.htm) contain an xor
>>engine for raid5 and raid6 calculations, but currently the md driver
>>does not fully utilize these resources.
>>    
>>
>
>the worst insult in the linux world is "solution in search of a problem".
>that applies here: are you sure that there is a problem?  yes, offload 
>can be a lovely thing, but it often falls behind the main driver of the 
>industry - host cpu performance.  unless you're specifically targetting
>a high-IO device with very little CPU power, I think you'll find a lot 
>of skepticism about IO coprocessors.
>
>I have a server that can do the raid5 checksum at 8 GB/s, and have no 
>reason to ever want more than ~100 MB/s on that machine.  do I care 
>about "wasting" 1/80th of the machine?  not really, even though it's 
>a supercomputing cluster node.  for fileservers, I mind even less 
>wasting CPU using the host for parity, since the cycles aren't going
>to be used for anything else...
>
>  
>
I think that the above holds for server applications, but there are lots 
of places where you will start to see a need for serious IO capabilities 
in low power, multi-core designs.  Think of your Tivo starting to store 
family photos - you don't want to bolt a server class box under your TV 
in order to get some reasonable data protection ;-)

In the Centera group where I work, we have a linux based box that is 
used for archival storage.  Customers understand why the cost of a box 
is related to the number of disks, but the strength of the CPU, memory 
subsystem, etc are all more or less thought of as overhead (not to 
mention that nasty software stuff that I work on ;-)).

In this kind of environment as well, finding an elegant way to take 
advantage of the capabilities of the new system on a chip parts is a win.

Also keep in mind that the Xor done for simple RAID is not the whole 
story - think of compression offload, encryption, etc which might also 
be able to leverage a well thought out solution.

ric

