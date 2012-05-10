From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: md RAID with enterprise-class SATA or SAS drives
Date: Thu, 10 May 2012 12:15:29 -0700
Message-ID: <hngt79xi6k.ln2@goaway.wombat.san-francisco.ca.us>
References: <4FAAE8F1.8000600@pocock.com.au>
 <CALFpzo5ObdwFATdT4e20znnxzU5hX9SVSfqJcdqOXM1FEYJQuw@mail.gmail.com>
 <4FABC7C6.4030107@turmel.org>
 <CALFpzo6BECrv2eTbSRKwUzpTopx_0EmD+UipqUf-XE=vzz2OnQ@mail.gmail.com>
 <4FABE724.40103@turmel.org>
 <otbt79xn1j.ln2@goaway.wombat.san-francisco.ca.us>
 <4FAC07AF.7000908@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-05-10, Phil Turmel <philip@turmel.org> wrote:
>
> I do them weekly...  the following is called from my crontab:
>
> #!/bin/bash
> #
> # Weekly Cron Job to initiate RAID scan/repair cycles
> for x in /sys/block/md*/md/sync_action ; do
>         echo check >$x
> done
> # Process occurs in background kernel tasks

Actually RHEL/CentOS has a nice utility script that will check your
arrays and emit an error via stdout/stderr if any mismatches are found.
Obviously you could have a separate cron job to check mismatch_cnt but I
think it's handy to have the check and the report self-contained--if
your cron is properly configured you'll get email on any mismatches.
It also has a config file where you can choose to ignore some arrays,
run a check on others, and run a repair on others.  (Presumably other
distros may have something similar.)

--keith

-- 
kkeller@wombat.san-francisco.ca.us


