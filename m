From: David Greaves <david@dgreaves.com>
Subject: Re: Raid5 or 6 here... ?
Date: Tue, 24 Oct 2006 15:50:58 +0100
Message-ID: <453E2852.6040209@dgreaves.com>
References: <4535F660.90901@cgv.tugraz.at> <Pine.LNX.4.56.0610241125580.24361@lion.drogon.net> <453E2472.8090207@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <453E2472.8090207@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
> Gordon Henderson wrote:
>>    1747 ?        S<   724:25 [md9_raid5]
>>
>> It's kernel 2.6.18 and
> 
> Wasn't the module merged to raid456 in 2.6.18?
> 
> Are your mdx_raid6's earlier kernels. My raid 6 is on 2.7.17 and says _raid6
> 
> Could it be that the combined kernel thread is called mdX_raid5
> 

Yup
raid5.c now handles 45 and 6 and says:
		mddev->thread = md_register_thread(raid5d, mddev, "%s_raid5");

I think I may actually be able to patch that...

David
