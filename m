From: Erik Boettcher <tehfoo@gmail.com>
Subject: Re: Raid 5 Recovery
Date: Sun, 22 Mar 2009 12:49:42 -0400
Message-ID: <125ed8800903220949k73b143ffyaca92464ad714f70@mail.gmail.com>
References: <125ed8800812272221y44e77849l886a80f32cbcfbec@mail.gmail.com>
	 <3513de790812280753k5c46799cj92a0e9566227fadc@mail.gmail.com>
	 <125ed8800812281002t6eecb5cbu2173efab36418c92@mail.gmail.com>
	 <125ed8800812281004o4d179064r735e46315481775a@mail.gmail.com>
	 <125ed8800812281013t59a3dc8cte44091d262cb8905@mail.gmail.com>
	 <20081228183921.GA5815@csy.ca>
	 <alpine.DEB.1.10.0812281714080.23996@p34.internal.lan>
	 <125ed8800903212015g4987fca9lbb8f42cfb2333a0d@mail.gmail.com>
	 <FCCA5C2A-C9B5-40CF-8DB7-5DDAC1663384@lambdalifting.org>
	 <125ed8800903220205l6c3efa1boecad13161de1754b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <125ed8800903220205l6c3efa1boecad13161de1754b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Max Amanshauser <linux-raid@lambdalifting.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok so I found the superblocks, backed them up, then created the array
(it was sdc,sdd,sde,sda,missing -- luckily I got that first time
around :).  I checked out the first few sectors of /dev/md0 and it
APPEARS to be LLVM, as shown below.  Now before I do anything that
writes the disks any more, I want to be sure that if I'm seeing this
I'm golden.  What do I need to do to bring the last disk back into the
array?

00000210  82 d3 36 66 20 00 00 00  4c 56 4d 32 20 30 30 31  |..6f ...LVM2 001|
00000220  75 67 35 77 55 43 59 6e  34 57 71 39 49 38 53 35  |ug5wUCYn4Wq9I8S5|
00000230  41 31 45 6d 69 79 71 32  51 78 68 42 39 63 32 78  |A1Emiyq2QxhB9c2x|

Many thanks for all of your help!
