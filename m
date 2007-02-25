From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: PATA/SATA Disk Reliability paper
Date: Sun, 25 Feb 2007 14:58:56 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702251256060.21918@coffee.psychology.mcmaster.ca>
References: <45D89FF5.3020303@sauce.co.nz> <200702251422.28079.a1426z@gawab.com>
 <Pine.LNX.4.64.0702251119300.21918@coffee.psychology.mcmaster.ca>
 <200702252057.22963.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200702252057.22963.a1426z@gawab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>> A good way to deal with reality is to find the real reasons for failure.
>>> Once these reasons are known, engineering quality drives becomes, thank
>>> GOD, really rather easy.
>>
>> that would be great, but depends rather much on relatively small number of
>> variables, which are manifest, not hidden.  there are billions of studies
>> (in medical/behavioral/social fields) which assume large numbers of more
>> or less hidden variables, and which still manage good success...
>
> Interesting.  Can you elaborate?

I'll give it a try - my wife wears the statistical pants in the family ;)
I was trying to say three things:

 	- disks are very complicated, so their failure rates are a
 	combination of conditional failure rates of many components.
 	to take a fully reductionist approach would require knowing
 	how each of ~1k parts responds to age, wear, temp, handling, etc.
 	and none of those can be assumed to be independent.  those are the
 	"real reasons", but most can't be measured directly outside a lab
 	and the number of combinatorial interactions is huge.

 	- factorial analysis of the data.  temperature is a good
 	example, because both low and high temperature affect AFR,
 	and in ways that interact with age and/or utilization.  this
 	is a common issue in medical studies, which are strikingly
 	similar in design (outcome is subject or disk dies...)  there
 	is a well-established body of practice for factorial analysis.

 	- recognition that the relative results are actually quite good,
 	even if the absolute results are not amazing.  for instance,
 	assume we have 1k drives, and a 10% overall failure rate.  using
 	all SMART but temp detects 64 of the 100 failures and misses 36.
 	essentially, the failure rate is now .036.  I'm guessing that if
 	utilization and temperature were included, the rate would be much
 	lower.  feedback from active testing (especially scrubbing)
 	and performance under the normal workload would also help.

in other words, I find the paper quite encouraging even inspiring!
while the raw failure rates are almost shocking, monitoring and replacement
appears to give reasonable results.  a particular "treatment schedule"
would need to minimize false-positive as well, unless disks taken out 
because of warning signs can be re-validated in some way.

(my organization has around 6300 disks and no coherent monitoring so far.)

regards, mark hahn.
