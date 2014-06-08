From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Sat, 7 Jun 2014 20:50:43 -0500
Message-ID: <CAAMCDeddsKzi71KDBPik5i+wBp+On3gochDs_PqKoP9bN2szCQ@mail.gmail.com>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com>
 <20140607075140.277c0880@natsu> <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>, Roman Mamedov <rm@romanrm.net>
List-Id: linux-raid.ids

Check messages file and see if it has in the last few weeks reporting
sectors bad.

Or do a dd if=/dev/sda of=/dev/null read test until it hits something,
then correct it, then continue on.

Or do repeated long/selective tests to see if you can find them.

Though, I had a seagate disk that I was able to get all of the pending
to be fixed, I had to remove the disk from the raid as it still would
randomly pause for 7 seconds while reading sectors that were not yet
classified as pending.   I tried a number of things to try to get the
disk to behave and/or replace those bad sectors, but finally gave up
on that disk and just replaced it (out of warranty) as I could not
ever get it to behave right.

On Sat, Jun 7, 2014 at 7:52 PM, Chris Murphy <lists@colorremedies.com> wrote:
> I wrote:
>> How can there still be pending bad sectors, and yet no error and LBA reported?
>
> So I started another -t long test. And it comes up with an LBA not previously reported.
>
> # 1  Extended offline    Completed: read failure       60%      1214         430234064
>
> # dd if=/dev/zero of=/dev/sda seek=430234064 count=8
> dd: writing to '/dev/sda': Input/output error
> 1+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 3.63342 s, 0.0 kB/s
>
> On this sector the technique fails.
>
> # dd if=/dev/zero of=/dev/sda seek=430234064 count=8 oflag=direct
> 8+0 records in
> 8+0 records out
> 4096 bytes (4.1 kB) copied, 3.73824 s, 1.1 kB/s
>
> This technique works.
>
> However, this seems like a contradiction. A complete -t long results in:
>
> # 1  Extended offline    Completed without error       00%      1219         -
>
> and yet
>
> 197 Current_Pending_Sector  0x0022   100   100   000    Old_age   Always       -       16
>
> How are there 16 pending sectors, with no errors found during the extended offline test? In order to fix this without SMART reporting the affected LBAs, I'd have to write to every sector on the drive. This seems like bad design or implementation.
>
> Chris Murphy
