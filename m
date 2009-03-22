From: Max Amanshauser <linux-raid@lambdalifting.org>
Subject: Re: Raid 5 Recovery
Date: Sun, 22 Mar 2009 08:15:16 +0100
Message-ID: <FCCA5C2A-C9B5-40CF-8DB7-5DDAC1663384@lambdalifting.org>
References: <125ed8800812272221y44e77849l886a80f32cbcfbec@mail.gmail.com> <3513de790812280753k5c46799cj92a0e9566227fadc@mail.gmail.com> <125ed8800812281002t6eecb5cbu2173efab36418c92@mail.gmail.com> <125ed8800812281004o4d179064r735e46315481775a@mail.gmail.com> <125ed8800812281013t59a3dc8cte44091d262cb8905@mail.gmail.com> <20081228183921.GA5815@csy.ca> <alpine.DEB.1.10.0812281714080.23996@p34.internal.lan> <125ed8800903212015g4987fca9lbb8f42cfb2333a0d@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <125ed8800903212015g4987fca9lbb8f42cfb2333a0d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Erik Boettcher <tehfoo@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 22, 2009, at 4:15 AM, Erik Boettcher wrote:

> Indeed recreating seems like my only option now.  I'd like to ensure
> the right creation order, so I'd like to ask for some help.  Attached
> is the output of 'mdadm -Evvvv /dev/sd{a,b,c,d,e}3'  Any help
> restoring this array is greatly appreciated!
> <mdadmEout>



I had the same problem recently and solved it relatively pain-free.


Basically what I did was:

*) Find out where the old superblocks are located and backup them with  
dd, just in case. Ideally you should backup all of the disks entirely  
(if they have errors, use dd_rescue and do the following on healthy  
disks).

*) Recreate with mdadm and the same options that were used when  
creating the raid in the first place, with one device declared missing.
"mdadm --create /dev/md0 -e 0.90 -c 32 -p left-asymmetric -l 5 -n 5 / 
dev/sdc3 /dev/sdd3 /dev/sde3 /dev/sdb3 missing" sounds about right in  
your case. I'd find out what the difference between 0.88 and 0.90  
superblocks is, though. If you have devices with errors you should  
declare the most broken one missing, of course. And make absolutely  
sure that the options are correct or you will overwrite innocent data.  
The device order is not so important, since you can change it in  
subsequent recreate attempts without breaking anything.

*) Try to read-only mount the array, and/or use dumpe2fs (if you have  
ext2/3). If it works, hurray. If not, recreate again with a different  
device order. Ultimately you will probably have to e2fsck to correct  
the damage.


I got the correct device order on the second attempt and lost only  
150kB due to hard disk errors. Guess I was lucky.

-- 
Good luck,
Max.

