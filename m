From: Brad Campbell <brad@wasp.net.au>
Subject: Re: 2.6.11-rc4 md loops on missing drives
Date: Mon, 21 Feb 2005 08:32:38 +0400
Message-ID: <42196466.6090607@wasp.net.au>
References: <4211FB59.7090104@wasp.net.au> <16914.37736.570163.440284@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <16914.37736.570163.440284@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday February 15, brad@wasp.net.au wrote:
> 
>>G'day all,
>>
>>I'm not really sure how it's supposed to cope with losing more disks than planned, but filling the 
>>syslog with nastiness is not very polite.
> 
> 
> Thanks for the bug report.  There are actually a few problems relating
> to resync/recovery when an array (raid 5 or 6) has lost too many
> devices.
> This patch should fix them.
> 

I applied your latest array of 9 patches to a vanilla BK kernel and did very, very horrible things 
to it while it was rebuilding. I can confirm that it does indeed tidy up the resync issues.

Ta!
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
