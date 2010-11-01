From: David Rees <drees76@gmail.com>
Subject: Re: Samsung F1 RAID Class SATA/300 1TB drives
Date: Mon, 1 Nov 2010 14:26:03 -0700
Message-ID: <AANLkTikZxyUzUmSZuHX5Pr9ynVohDozSo8xoB=9wTTqv@mail.gmail.com>
References: <AANLkTi=CL-EH1HjJ3eTvVL51hT7nF7GA62rxvPqBFGD8@mail.gmail.com> <4CCA0948.3060600@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CCA0948.3060600@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Oct 28, 2010 at 4:37 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 29/10/2010 00:17, Mark Knecht wrote:
>> I saw in Fry's San Jose ad today they were selling these
>> Serial-ATA/300 drives for $67. They didn't give a model number but
>> scouting around a bit on the web I'm guessing they are a discontinued
>> model.
>>
>> Any inputs on whether these are drives that work well with mdadm RAID?
>> Do they support TLER and otherwise work well?
>>
>> This would just be a home server of some type, nothing industrial.
>> Probably a 3 drive RAID-1 or something like that.
>
> Well, they're perhaps not great. I bought three and after only about a
> thousand hours one of them was giving SMART errors, then after about 7,500
> hours a second one started doing it too. At that point I replaced both with
> other makes, copying over with ddrescue (or maybe it was dd_rescue), which
> worked without any failed sectors, then ran badblocks -w on the Samsungs and
> the SMART errors went away. The third one of mine is still fine, and the
> other two are now in a ReadyNAS giving good service.

I think that using two different brand drives in general is a good idea.

We recently had 2 500 GB WD5000AAKS drives die at the same time over a
weekend.  Both of them suffered from the same death and would no
longer spin up - just making a clicking/whirring sound when you
powered it on.

Luckily we had backups for most of the data on there, but some
non-critical (but time consuming to manually restore) data had to be
reconstructed.

I understand that drives from the same batch will often die around the
same period of time - from now on we plan on trying to use dissimilar
drives when possible.

First time we've seen 2 drives in one array die that close together
and that catastrophically, though.

-Dave
