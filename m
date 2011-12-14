From: Troy Telford <ttelford.groups@gmail.com>
Subject: Re: RAID-6 disk superblock issue
Date: Wed, 14 Dec 2011 15:08:27 -0700
Message-ID: <jcb6or$d3g$1@dough.gmane.org>
References: <jc8kca$mf$1@dough.gmane.org> <4EE8F26D.7010608@turmel.org> <jcb570$1do$1@dough.gmane.org> <CAK2H+eeGpUzxTm_Mn-TCdB4uLHtRABnE-NRxcVJ6ChrnT2ggZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2011-12-14 22:04:12 +0000, Mark Knecht said:

> On Wed, Dec 14, 2011 at 1:41 PM, Troy Telford 
> <ttelford.groups@gmail.com> wrote:
> <SNIP>
>> 
>> Unfortunately, I'm not sure how to get my current superblock version:
>> $ sudo mdadm --examine /dev/md2
>> mdadm: No md superblock detected on /dev/md2.
>> 
> 
> use --detail instead:
> 
> c2stable ~ # mdadm --detail /dev/md126 | grep Version
>         Version : 0.90
> c2stable ~ #
> 
> HTH,
> Mark

Yup. 0.90
$ sudo mdadm --detail /dev/md2
/dev/md2:
        Version : 0.90
  Creation Time : Tue Oct 27 09:45:39 2009

Wow.  It's younger than I thought.

Thanks!
-- 
Troy Telford


