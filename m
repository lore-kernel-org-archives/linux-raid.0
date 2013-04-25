From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Thu, 25 Apr 2013 05:56:41 -0500
Message-ID: <51790BE9.30503@hardwarefreak.com>
References: <5171CBF9.9020701@redhost.ro> <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro> <51747382.1010105@hardwarefreak.com> <5a749bb56c88b6d6b8a806694b163bda@redhost.ro> <5175F71A.8030805@hardwarefreak.com> <51765FD7.8090309@redhost.ro> <51775078.3000500@hardwarefreak.com> <51779720.6040109@redhost.ro> <51780A3F.80104@hardwarefreak.com> <517852D2.2050109@redhost.ro>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <517852D2.2050109@redhost.ro>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Banu <andrei.banu@redhost.ro>
List-Id: linux-raid.ids

On 4/24/2013 4:46 PM, Andrei Banu wrote:

> 1. How can I at least start trying to find the daemon that might be
> doing this?

For you, I'd say grab a bucket of popcorn and watch top and iotop for a
while during peak use periods.  Fire up two ssh sessions and watch both
simultaneously, left and right on your screen.  You need to become
familiar with your system, what the applications are doing to cpu, mem,
and io.

When you're not doing that, use Google.  Start reading about problems
others have with "[jbd2/]" and/or super slow performance with very fast
SSDs.

> 2. I am not sure what real time TRIM is. I thought there was the
> 'discard' option in
> fstab (which I tried and didn't help) and other command like trims

discard = realtime trim

If it's not enabled then this isn't the source of your problem.

> I am not really sure where do I go from here. I am a bit lost as it
> seems we hit
> a dead end.

There's only so much we can do.  The problem appears to have nothing to
do with md/RAID.  I'm doing my best to point you in the right
direction(s), but I'm neither a CentOS nor EXT4 user and am not familiar
with those ecosystems nor support channels.

You need to research your problem via Google, interface with other
CentOS users and others using the same type of cpanel based hosting
software stack.

If I had access to the box I'm sure I could figure this out for you, but
this isn't something I'm willing to do at this time.

Keep at it and you'll eventually figure it out.  And you'll learn a lot
along the way.

Best of luck.

-- 
Stan



> Thanks!
> Andrei Banu
> 
> On 24/04/2013 7:37 PM, Stan Hoeppner wrote:
>> On 4/24/2013 3:26 AM, Andrei Banu wrote:
>>
>>> Total DISK READ: 0.00 B/s | Total DISK WRITE: 0.00 B/s
>>>    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO> COMMAND
>>>    541 be/3 root        0.00 B/s    0.00 B/s  0.00 % 96.96 %
>>> [jbd2/md2-8]
>> This seems to be your problem.  jbd2 (journal block device) is causing
>> 97% iowait, yet without doing much physical IO.  This is a component of
>> EXT4.  As this will fire intermittently it explains why you see such a
>> wide throughput gap between tests at different points in time.
>>
>> This isn't a bug or Google would reveal that.  Andrei, you need to
>> identify which daemon or kernel feature is causing this.  Do you happen
>> to have realtime TRIM enabled?  It is well known to bring IO to a crawl.
>>
>> If not realtime TRIM, I'd guess you turned a knob you should not have in
>> some config file, causing a daemon to frequently issue a few gazillion
>> atomic updates.
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

