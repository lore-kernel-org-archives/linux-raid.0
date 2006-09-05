From: Luca Berra <bluca@comedia.it>
Subject: Re: Care and feeding of RAID?
Date: Tue, 5 Sep 2006 22:57:27 +0200
Message-ID: <20060905205727.GD17634@percy.comedia.it>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net> <44FD91D1.7090501@maine.edu> <20060905154156.GB28548@scavenger.homeip.net> <44FDC21C.7050203@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44FDC21C.7050203@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
List-Id: linux-raid.ids

On Tue, Sep 05, 2006 at 02:29:48PM -0400, Steve Cousins wrote:
>
>
>Benjamin Schieder wrote:
>>On 05.09.2006 11:03:45, Steve Cousins wrote:
>>
>>>Would people be willing to list their setup? Including such things as 
>>>mdadm.conf file, crontab -l, plus scripts that they use to check the 
>>>smart data and the array, mdadm daemon parameters and anything else that 
>>>is relevant to checking and maintaining an array? 
>>
>>
>>Personally, I use this script from cron:
>>http://shellscripts.org/project/hdtest

nice race :)

>I am checking this out and I see that you are the writer of this script.
>I'm getting errors when it comes to lines 76 and 86-90 about the 
>arithmetic symbols. This is on a Fedora Core 5 system with bash version 
that is because smartctl output has changed and the grep above returns
no number.

>3.1.7(1).   I weeded out the smartctl command and tried it manually with 
>no luck on my SATA /dev/sd? drives.

which command?

>What do you (or others) recommend for SATA drives?

smartmontools and a recent kernel just work.
also you can schedule smart tests with smartmontools. so you don't need
to cron scripts.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
