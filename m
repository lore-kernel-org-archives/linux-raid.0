From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Wed, 24 Apr 2013 11:37:19 -0500
Message-ID: <51780A3F.80104@hardwarefreak.com>
References: <5171CBF9.9020701@redhost.ro> <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro> <51747382.1010105@hardwarefreak.com> <5a749bb56c88b6d6b8a806694b163bda@redhost.ro> <5175F71A.8030805@hardwarefreak.com> <51765FD7.8090309@redhost.ro> <51775078.3000500@hardwarefreak.com> <51779720.6040109@redhost.ro>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51779720.6040109@redhost.ro>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Banu <andrei.banu@redhost.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/24/2013 3:26 AM, Andrei Banu wrote:

> Total DISK READ: 0.00 B/s | Total DISK WRITE: 0.00 B/s
>   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO> COMMAND
>   541 be/3 root        0.00 B/s    0.00 B/s  0.00 % 96.96 % [jbd2/md2-8]

This seems to be your problem.  jbd2 (journal block device) is causing
97% iowait, yet without doing much physical IO.  This is a component of
EXT4.  As this will fire intermittently it explains why you see such a
wide throughput gap between tests at different points in time.

This isn't a bug or Google would reveal that.  Andrei, you need to
identify which daemon or kernel feature is causing this.  Do you happen
to have realtime TRIM enabled?  It is well known to bring IO to a crawl.

If not realtime TRIM, I'd guess you turned a knob you should not have in
some config file, causing a daemon to frequently issue a few gazillion
atomic updates.

-- 
Stan

