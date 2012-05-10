From: Phil Turmel <philip@turmel.org>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 14:23:43 -0400
Message-ID: <4FAC07AF.7000908@turmel.org>
References: <4FAAE8F1.8000600@pocock.com.au> <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com> <4FABC7C6.4030107@turmel.org> <CALFpzo6BECrv2eTbSRKwUzpTopx_0EmD+UipqUf-XE=vzz2OnQ@mail.gmail.com> <4FABE724.40103@turmel.org> <otbt79xn1j.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <otbt79xn1j.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/10/2012 01:53 PM, Keith Keller wrote:
> On 2012-05-10, Phil Turmel <philip@turmel.org> wrote:
>>
>> Frequent array checks are not optional, if you want flush out any UREs
>> in the making, and maximize your odds of successfully rebuilding after
>> a drive replacement.  If you are running RAID6 or a triple mirror, with
>> frequent checks, you are very safe.
> 
> How frequent do people define as "frequent"?  I typically do monthly
> checks, but perhaps I should be doing them weekly.

I do them weekly...  the following is called from my crontab:

#!/bin/bash
#
# Weekly Cron Job to initiate RAID scan/repair cycles
for x in /sys/block/md*/md/sync_action ; do
        echo check >$x
done
# Process occurs in background kernel tasks

