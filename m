From: Bill Cizek <cizek@rcn.com>
Subject: Re: raid5 reshape bug with XFS
Date: Sun, 05 Nov 2006 23:48:58 -0600
Message-ID: <454ECCCA.9080704@rcn.com>
References: <454D459D.4000003@rcn.com> <17742.27688.120840.900652@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17742.27688.120840.900652@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Saturday November 4, cizek@rcn.com wrote:
>   
>> Hi,
>>
>> I'm setting up a raid 5 system and I ran across a bug when reshaping an 
>> array with a mounted XFS filesystem on it.  This is under linux 2.6.18.2 
>> and mdadm 2.5.5
> You have CONFIG_LBD=n don't you?
>   
Yes,

I have CONFIG_LBD=n

...and the patch fixed the problem.

Side Note: I just converted 2 raid0 drives into a 4 drive raid5 array 
in-place, with relative ease.
I couldn't have done it without the work you (and I'm sure others) have 
done. Thanks.

-Bill


