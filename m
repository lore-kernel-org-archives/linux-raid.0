From: David Greaves <david@dgreaves.com>
Subject: Re: MD Feature Request: non-degraded component replacement
Date: Tue, 16 Dec 2008 12:56:37 +0000
Message-ID: <4947A585.4030203@dgreaves.com>
References: <49477689.2010208@dgreaves.com> <alpine.DEB.1.10.0812160450080.28063@p34.internal.lan> <49478924.9010004@cgv.tugraz.at> <alpine.DEB.1.10.0812160636390.725@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812160636390.725@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Lars Schimmer <l.schimmer@cgv.tugraz.at>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> On Tue, 16 Dec 2008, Lars Schimmer wrote:
>> Justin Piszcz wrote:
>>> On Tue, 16 Dec 2008, David Greaves wrote:
>>>> of course that's just one opinion after replacing about 20 flaky 1Tb
>>>> drives in
>>>> the past 6 months :)
>>> What were the make/model of those drives, how did they fail?
>>
>> Far more important: how much do you have in production?
>> AS I got roughly 15 Seagate 1 GB HDs here and not one of them failed for
>> the last year.
>> And 20 of 30 running is really bad, but 20 from 500 running is not as
>> bad as it seems ;-)
> Agree, but I would still be interested in the make/model and what
> controller they were attached to and how they failed?

This is a home environment; (MythTV doncha know).

I bought 9 Samsung HD103UJ 1Tb drives in June 2008.

Since June I have RMAed 5 of the original 9.
I have then RMAed 3 of the 5 replacements.
I have then RMAed 2 of the 3 re-replacements.
And finally I RMAed 1 of the 2 re-re-replacements. (I think - I was confused at
this point - I have a list of 18+ serial numbers anyway)

In November (ish) Samsung did the decent thing and replaced all 9 with HE103UJ
(enterprise) drives; no 'moaning' about using them in RAID etc.

This weekend I replaced 3 of the HE models that were displaying essentially the
same problems (all on the same machine - the vast majority of the problems were
in this machine and, as it happens, the 3 in the md array).
During the replication I got a real media failures.

Anyhow...

I am using Dell SC420 chassis (SOHO class).
I am running 2.6.18-xen on one system, 2.6.25.4 on another. The controllers are
cheap dual-channel Sil24 PCIe cards and the Dell onboard controller.

When I found smartctl -l scttempsts I can see that peak temperature is 44C
They are running in Dell servers in a cool environment; and previously these
servers supported many more drives.

I had one smart DMA error which I'll attribute to a transient problem with a cable.

All the other 'problems' are when SMART long self tests show eg:
21 # 1  Extended offline    Completed: read failure       90%       424         4239
and
  1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail  Always       -
      62

I'm not aware of any OS level issues but I have had some; I've not recorded them
as I'm taking the SMART self-test to be enough to indicate dodgy disks.

I've never had any with Reallocated_Sector_Ct != 0

I also note that the smart self test log does indeed show inconsistent summary
messages:
# 1  Short offline       Completed: read failure       20%      1236
1953517887
# 2  Short offline       Aborted by host               20%      1212         -
# 3  Short offline       Aborted by host               10%      1188         -
# 4  Short offline       Aborted by host               10%      1164         -

In fact each log shows "Completed: read failure" until the next log pushes it
down the stack; at that point it shows "Aborted by host". The % remaining is
key. Discussion on the smart list suggests that this is a firmware bug. (Indeed
this is now fixed on some newer RMA replacements).

Also note that the LBA failure has been different (but very similar) for each
drive but consistent once it occurs. It often but not always goes away if I
force (dd) a read/write of the reported sector.

I am in touch with a guy at Samsung who is interested in the problem but I've
not had any tech feedback.

David
PS Thanks to Samsungs excellent advance replacement RMA service I have been able
 to deal with these problems. No other drive maker offers this service in the UK
AFAIK. Of course I have spent *days* just ddrescue-ing disks. But I've not had
to use a backup yet despite *loads* of dual-drive+ failures.

-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
