From: Brett Russ <bruss@netezza.com>
Subject: Re: Why does one get mismatches?
Date: Wed, 20 Jan 2010 10:34:00 -0500
Message-ID: <hj77p7$rsr$1@ger.gmane.org>
References: <387070.15704.qm@web51305.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <387070.15704.qm@web51305.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/20/2010 10:03 AM, Jon Hardcastle wrote:
> --- On Wed, 20/1/10, Brett Russ<bruss@netezza.com>  wrote:
>> What do you mean by mismatches detected?  How is this observed?
>
> cat /sys/block/md4/md/mismatch_cnt

Someone else will need to comment on what this value pertains to and how 
it should behave.

> I have been able to get the info you asked for using mdadm -E but not
> with the array stopped. I cant stop it just yet. What would you be
> looking for in this data?

Simply that the "Update Time" and "Events" values matched across all 
members, which they do.

-BR

