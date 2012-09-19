From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: make filesystem failed while the capacity of raid5 is big than
 16TB
Date: Wed, 19 Sep 2012 11:00:42 -0500
Message-ID: <5059EC2A.7070407@hardwarefreak.com>
References: <505033fe.8aec440a.5d52.ffffe37b@mx.google.com> <50504094.2040302@hesbynett.no> <CACY-59cLmV2SRY+FrvhHxseDD1+r-B-3bOKPGzJdGttW+9U2mw@mail.gmail.com> <505059DD.8000108@hesbynett.no> <CACY-59dAbS=8ncRAeZrAYBAvo7G6FEyoGREHtC-ze4cwhiF9GQ@mail.gmail.com> <5051DEC3.9050703@hardwarefreak.com> <CACY-59eJvv98xz_E-0qO_MGF8M40AZ-bCeXOA6zscd+HZdsy+g@mail.gmail.com> <50584B75.1060606@hesbynett.no> <5058E9DF.6090007@hardwarefreak.com> <5059722D.1070409@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5059722D.1070409@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: GuoZhong Han <hanguozhong@meganovo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/19/2012 2:20 AM, David Brown wrote:
> On 18/09/2012 23:38, Stan Hoeppner wrote:

>> Actually, no.  The level of parallelism is the same--30 concurrent
>> writes.  As noted above, the increase in performance comes from locating
>> each of the AGs on a different disk, or array.  This decreases the
>> number of seeks requires per write, especially with parity arrays.

> OK, so you get 30 parallel logical writes, but if it does not translate
> into multiple parallel physical writes to the disks by having multiple
> member disks, then the gains are small.

The problem in the OP's case isn't a lack of physical write parallelism,
but most likely a problem of seek starvation caused by write parallelism.

-- 
Stan

