From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID 4 and RAID 5
Date: Tue, 15 Oct 2002 20:25:20 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15787.60688.596988.799195@notabene.cse.unsw.edu.au>
References: <3DABCC4A.9070206@webmail.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Vladimir Milovanovic on Tuesday October 15
To: Vladimir Milovanovic <vlad@webmail.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 15, vlad@webmail.co.za wrote:
> 
> Now here is the crunch : both RAID 4 and RAID 5 give me EXACTLY the same 
> results, both in read write performance. I am using many programs for 
> benching, hdparm, bonnie, iozone, tiobench and the results are 
> consistent and repeatable.
> 
> Does anyone know with any degree of certainity whether RAID 4 is 
> supported in Linux? What exactly is the status of that? I know that 
> there is no point in using RAID 4 over RAID 5 but I want to know so that 
> I am able to document it.

raid4 is definately supported in linux.  It is supported by the raid5
driver so there is a possibility of some confusion.  However it sounds
like you are setting it up correctly.

You would only expect to see a performance difference between raid5
and raid5 when doing lots of small widely distributed random writes.
You would probably also need a fairly large array (at least 5 drives)
to be able to measure much and you would need to be sure that none of
the busses are in a position to cause a bottle neck.  Basically you
need to get the raid4 parity drive overloaded with parity read/updates
before you will see it slow down.

NeilBrown
