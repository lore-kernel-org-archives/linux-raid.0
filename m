From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: Care and feeding of RAID?
Date: Tue, 05 Sep 2006 14:29:48 -0400
Message-ID: <44FDC21C.7050203@maine.edu>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net> <44FD91D1.7090501@maine.edu> <20060905154156.GB28548@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060905154156.GB28548@scavenger.homeip.net>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Benjamin Schieder wrote:
> On 05.09.2006 11:03:45, Steve Cousins wrote:
> 
>>Would people be willing to list their setup? Including such things as 
>>mdadm.conf file, crontab -l, plus scripts that they use to check the 
>>smart data and the array, mdadm daemon parameters and anything else that 
>>is relevant to checking and maintaining an array? 
> 
> 
> Personally, I use this script from cron:
> http://shellscripts.org/project/hdtest

Hi Benjamin,

I am checking this out and I see that you are the writer of this script.
I'm getting errors when it comes to lines 76 and 86-90 about the 
arithmetic symbols. This is on a Fedora Core 5 system with bash version 
3.1.7(1).   I weeded out the smartctl command and tried it manually with 
no luck on my SATA /dev/sd? drives.

What do you (or others) recommend for SATA drives?

Thanks,

Steve


