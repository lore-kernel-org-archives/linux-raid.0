From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Thu, 25 Apr 2013 00:46:58 +0300
Message-ID: <517852D2.2050109@redhost.ro>
References: <5171CBF9.9020701@redhost.ro> <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro> <51747382.1010105@hardwarefreak.com> <5a749bb56c88b6d6b8a806694b163bda@redhost.ro> <5175F71A.8030805@hardwarefreak.com> <51765FD7.8090309@redhost.ro> <51775078.3000500@hardwarefreak.com> <51779720.6040109@redhost.ro> <51780A3F.80104@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51780A3F.80104@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

1. How can I at least start trying to find the daemon that might be 
doing this?

2. I am not sure what real time TRIM is. I thought there was the 
'discard' option in
fstab (which I tried and didn't help) and other command like trims 
(fstrim - which
errors out when run on / or mdtrim that seems somebody's experiment). But I
am not sure what real time trim might be.

I am not really sure where do I go from here. I am a bit lost as it 
seems we hit
a dead end.

Thanks!
Andrei Banu

On 24/04/2013 7:37 PM, Stan Hoeppner wrote:
> On 4/24/2013 3:26 AM, Andrei Banu wrote:
>
>> Total DISK READ: 0.00 B/s | Total DISK WRITE: 0.00 B/s
>>    TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO> COMMAND
>>    541 be/3 root        0.00 B/s    0.00 B/s  0.00 % 96.96 % [jbd2/md2-8]
> This seems to be your problem.  jbd2 (journal block device) is causing
> 97% iowait, yet without doing much physical IO.  This is a component of
> EXT4.  As this will fire intermittently it explains why you see such a
> wide throughput gap between tests at different points in time.
>
> This isn't a bug or Google would reveal that.  Andrei, you need to
> identify which daemon or kernel feature is causing this.  Do you happen
> to have realtime TRIM enabled?  It is well known to bring IO to a crawl.
>
> If not realtime TRIM, I'd guess you turned a knob you should not have in
> some config file, causing a daemon to frequently issue a few gazillion
> atomic updates.
>

