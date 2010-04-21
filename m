From: Tim Small <tim@seoss.co.uk>
Subject: Re: Use of WD20EARS with MDADM
Date: Wed, 21 Apr 2010 14:45:38 +0100
Message-ID: <4BCF0182.40400@seoss.co.uk>
References: <4BAB8D41.4010801@gmail.com> <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com> <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net> <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com> <4BCEFB99.9080806@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BCEFB99.9080806@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
>> I believe that these disks only come in the "green" variety.  I recently
>> picked up a 1.5 tb version for testing and cheap bulk storage, and I
>> would not suggest using them in a raid array because the green drives
>> firmware automatically parks the head after 8 seconds of inactivity and
>> reduces the rpm of the disk.  The constant parking can quickly wear out
>> the head under high use and there is no way to disable this "feature".
>>   
>
> I hear this said, but I don't have any data to back it up. Drive
> vendors aren't stupid, so if the parking feature is likely to cause
> premature failures under warranty, I would expect that the feature
> would not be there, or that the drive would be made more robust. Maybe
> I have too much faith in greed as a design goal, but I have to wonder
> if load cycles are as destructive as seems to be the assumption.

I've used the 500G, and 2TB WD consumer green drives in md arrays, not
many - about 10 in total.  The older 500G drives (like many WD 2.5"
drives) did frequent head unload/reloads under Linux due to interactions
with the default timings of the Linux block layer, I believe.  This can
be fixed using WD's wdidle3.exe under DOS.  You can monitor this using
smartctl - look at the raw value for unloads, but it shouldn't be an
issue with newer drives.

Both the 2TB and 500G drives seem to lock up and need resetting by Linux
(this happens automatically) if you poll the SMART status e.g. you run
smartd, or munin+smartctl etc. (the 2TB drives that I've had also seem
to occasionally lock up under other workloads, but you might be able to
live with this) - the SMART thing might be a firmware bug but WDC say
"contact your Linux vendor" - they only provide support for Windows - I
must get around to polling one of them for SMART under Windows XP for
comparison.

If you're going to be trying to use a load of them in a RAID, then you
need to be careful about vibration damping - they may not cope that well
with vibration (check SMART high-fly-writes and hardware-ecc-recovered
raw values if available).  They are also not rated for 24/7 operation, I
believe.

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.  
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

