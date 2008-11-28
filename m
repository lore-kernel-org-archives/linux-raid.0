From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [RFC patch 1/1] Track raid5/6 statistics.
Date: Fri, 28 Nov 2008 12:21:10 -0500
Message-ID: <49302886.4040609@tmr.com>
References: <20081126190452.775333692@sun.com> <20081126190854.813151413@sun.com> <20081127114748.GE14570@boogie.lpds.sztaki.hu> <20081127135248.GD29919@clouds> <20081127171535.GL14570@boogie.lpds.sztaki.hu> <20081127182912.GE29919@clouds>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081127182912.GE29919@clouds>
Sender: linux-raid-owner@vger.kernel.org
To: Jody McIntyre <scjody@sun.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Jody McIntyre wrote:
> On Thu, Nov 27, 2008 at 06:15:35PM +0100, Gabor Gombas wrote:
>
>   
>> /proc contains a lot of legacy junk but nowadays the trend is that you
>> should not add new files under /proc that are not process-related.
>>     
>
> Agreed.  I'm not proposing that at all.
>
>   
>> Changing /proc/mdstat is IMHO out of question since it is part of the
>> user visible ABI and breaking that is a big no-no. So if you want all
>> info in a single file that pretty much leaves only debugfs.
>>     
>
> AFAICT it was last changed on 2005-09-09 (appearing in 2.6.14).  This
> suggests we can change it given a sufficiently good reason.
>   

I have to think that providing information useful to a subset of users, 
while possibly breaking existing tools, is going to be a hard sell and 
probably indefensible, since your new stuff could as well go in a new 
file in /sys or even debugfs. I would rather not see you mix policy with 
the technical features of these patches. I'd rather not see you do 
anything which makes my fragile perl scripts break, either. ;-)

I think this is a step in the right direction, tuning an array is always 
time consuming, and I suspect that many of us settle for "better" rather 
than "optimal" just for that reason.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


