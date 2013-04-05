From: Peter Maloney <peter.maloney@brockmann-consult.de>
Subject: Re: RAID barely usable on my home machine
Date: Fri, 05 Apr 2013 10:58:46 +0200
Message-ID: <515E9246.3080200@brockmann-consult.de>
References: <CAO=zWDLfnBJBFgm4H67XEqsKPP=+Ayk3Jd4OUdEfmLXsvNGdog@mail.gmail.com> <CAAMCDeeY1S+TMyiFpVjEFX3K66JaxcwBFV+zDRD6eyRfM2Qxsw@mail.gmail.com> <CAO=zWD+5GHjJCD0Z64ZQFR=98ysRyd0o2U=t4ER8mJaSpwQDuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAO=zWD+5GHjJCD0Z64ZQFR=98ysRyd0o2U=t4ER8mJaSpwQDuQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Maik Zumstrull <maik@zumstrull.net>
Cc: Roger Heflin <rogerheflin@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, 700975 <700975@bugs.debian.org>
List-Id: linux-raid.ids

On 2013-04-05 10:06, Maik Zumstrull wrote:
> On Fri, Apr 5, 2013 at 2:16 AM, Roger Heflin <rogerheflin@gmail.com> wrote:
>
>> lspci look like this for the controller:
>> SATA controller: Marvell Technology Group Ltd. Device 9230 (rev 10)
>>
>> 4pt sata3.0 6gbit or is yours a different one?
> Mine looks slightly different (included somewhere in my mail), but
> should be a device in the same family.
>
>> I have the issue also, I have eliminated all smart hits against the
>> disks and no incidents since then.
> Not a great workaround as such, first of all, running SMART against
> your storage is kind of recommended, and secondly, as I said, udisks2
> will also SMART your disks occasionally, which you have to uninstall
> parts of GNOME to get rid of.
This reminds me of an old thread in freebsd-scsi, where a guy with some
SAS disks and a SAS2008 controller would have his disks 'lost' if he
used smartctl on routine, and could reproduce it reliably by spamming a
disk with smartctl -a (but smartctl -i, and something else would not
reproduce it). And he found that to solve it, he can change the "disk
tags" to much lower. I think "disk tags" might be equivalent to the
nr_requests in Linux.

Here is the thread:
http://osdir.com/ml/freebsd-scsi/2011-11/msg00006.html
>> I have seagate 1.5tb drives on mine that had had the issues.
> Suggests it's not something about my drives, as I have WD Red disks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

--------------------------------------------
Peter Maloney
Brockmann Consult
Max-Planck-Str. 2
21502 Geesthacht
Germany
Tel: +49 4152 889 300
Fax: +49 4152 889 333
E-mail: peter.maloney@brockmann-consult.de
Internet: http://www.brockmann-consult.de
--------------------------------------------

