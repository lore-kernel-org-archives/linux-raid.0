From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Software RAID and TRIM
Date: Thu, 30 Jun 2011 07:51:01 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1106300746460.19581@uplift.swm.pp.se>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com> <alpine.OSX.2.00.1106291133060.257@trogdor.csi.cam.ac.uk> <iuf6me$9us$1@dough.gmane.org>
 <alpine.OSX.2.00.1106291348430.257@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-533477880-1309413061=:19581"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1106291348430.257@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tom De Mulder <tdm27@cam.ac.uk>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-533477880-1309413061=:19581
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 29 Jun 2011, Tom De Mulder wrote:

> I have a set of 4 Intel 510 SSDs purely for testing, and I have used 
> these to simulate the kinds of workload I would expect them to 
> experience in a server environment (focused mainly on database access). 
> So far, those tests have focused on using single drives (ie. without 
> RAID) on a variety of controllers.

From the tests I have read, the Intel 510 are actually worse than the 
Intel X-25 G1/G2/320 models, with exactly the symptoms you're describing. 
It's fast for linear reads and writes, but not so good for random writes, 
especially not when it's getting full.

> Once the drives get fuller (something which does happen on servers) I do 
> indeed see write latencies that are in the order of several seconds (I 
> saw from 1500µs to 6000µs), as the drive suddenly struggles to free 
> entire blocks, where initially latency was in the single digits.

Yeah, this is a common problem especially for older drives. A lot has 
happened with garbage collect but the fact is still that a lot of SSD 
vendors have too little spare area, so the recommendation you make 
regarding leaving a large area unused is something I do as well, and it 
works.

> I am hoping to get my hands on some Sandforce controller-based SSDs as well, 
> to compare, but even they show degradation as they get fuller in AnandTech's 
> tests (and those tests seem, IME, trustworthy).

Include the Intel 320 as well, I think it should be viable for your usage 
pattern.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-533477880-1309413061=:19581--
