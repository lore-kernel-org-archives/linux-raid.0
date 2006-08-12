From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Resize on dirty array?
Date: Sat, 12 Aug 2006 08:36:11 +0400
Message-ID: <44DD5ABB.1090804@wasp.net.au>
References: <44D7DC93.2070905@net1plus.com> <44D8E535.9080208@net1plus.com>	 <17625.24594.568139.430440@cse.unsw.edu.au>	 <44D9C6F5.7070501@net1plus.com>	 <68c491a60608090437l7e3b583el2214cbe6f01009ab@mail.gmail.com>	 <Pine.LNX.4.64.0608090846160.16324@coffee.psychology.mcmaster.ca>	 <44D9E41C.4050608@net1plus.com>	 <Pine.LNX.4.64.0608101031330.2920@twinlark.arctic.org>	 <72dbd3150608111810m4e4a2e07r5ddcee2132dd6d9a@mail.gmail.com>	 <Pine.LNX.4.64.0608111813250.29322@twinlark.arctic.org> <72dbd3150608111905g43ac320bn1ab30cbe021a3f43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150608111905g43ac320bn1ab30cbe021a3f43@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: dean gaudet <dean@arctic.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Rees wrote:
>> > I personally prefer to do a long self-test once a week, a month seems
>> > like a lot of time for something to go wrong.
>>
>> unfortunately i found some drives (seagate 400 pata) had a rather 
>> negative
>> effect on performance while doing self-test.
> 
> Interesting that you noted negative performance, but I typically
> schedule the tests for off-hours anyway where performance isn't
> critical.

Personally I have every disk do a short test at 6am Monday-Saturday, and then they *all* (29 of 
them) do a long test every Sunday at 6am.

I figure having all disks do a long test at the same time rather than staggered is going to show up 
any pending issues with my PSU's also.

(Been doing this for nearly 2 years now and had it show up a couple of drives that were slowly 
growing defects. Nothing a dd if=/dev/zero of=/dev/sd(x) did not fix though)

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
