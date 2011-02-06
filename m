From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What's the typical RAID10 setup?
Date: Sat, 05 Feb 2011 22:27:32 -0600
Message-ID: <4D4E2334.3060009@hardwarefreak.com>
References: <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <4D475AB5.10600@hardwarefreak.com> <20110203110428.GA26762@www2.open-std.org> <4D4B3DAE.3070502@hardwarefreak.com> <20110204070613.GA3788@www2.open-std.org> <4D4BB87A.30800@hardwarefreak.com> <20110204090602.GA4017@www2.open-std.org> <20110204204251.GB6603@www2.open-std.org> <4D4C6C7B.2020304@hardwarefreak.com> <20110204220507.GA6876@www2.open-std.org> <4D4C85D3.2030903@hardwarefreak.com> <AANLkTinMD6uFJf1norPTQZ=8fYN0NmoJTPyQLBLXrNbK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinMD6uFJf1norPTQZ=8fYN0NmoJTPyQLBLXrNbK@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: =?UTF-8?B?S2VsZCBKw7hybiBTaW1vbnNlbg==?= <keld@keldix.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Drew put forth on 2/5/2011 9:59 PM:
>> No, it's not.  I see no mention of "RAID 1+0" anywhere in SNIA documents.  I
>> _do_ see "RAID 10" casually mentioned in many places in their documents.  But
>> I've yet to find where they define or bother to minimally explain the term "RAID
>> 10".  In technical writing you must define something before you discuss or
>> reference it.
> 
> It's not explicitly defined but it's there.

Do you agree that they should give a cursory definition of RAID 10 in the DDF,
since they reference it at least once by name in the same document?

> Page 84, Section 4.3 Secondary RAID Level
> 
> "Table 15 lists values used in the Secondary_RAID_Level field of the
> Virtual Disk Configuration Record
> (Section 5.9.1) and their definitions. The table defines secondary
> RAID levels such as Striped, Volume
> Concatenation, Spanned, and Mirrored for hybrid or multilevel virtual
> disks. The Secondary_RAID_Level
> field in the Virtual Disk Configuration Record MUST use the values
> defined in Table 15."

Yes, I obviously read all of this searching for a sign of a RAID 10 like
definition.  My whole point on this though is that they use the
description/phrase "RAID 10" in passing, yet there is no other reference to it
in the document.

> As a somewhat related aside I ran into this on an IBM x3650 I was
> configuring for an office a few months back. IBM explicitly stated
> support for RAID 10 but the process for setting up the RAID 10 array
> involved setting up a pair of mirrored disks which the RAID controller
> then recognized as components it could use to build a RAID 10 array.

I believe this is relatively new.  Once upon a time LSI made SCSI ASICs and that
was about it.  Then they bought Mylex, a RAID card company, and then bought the
RAID card division of American Megatrends (aka AMI BIOS) to eliminate all the
major competition (years later they swallowed 3Ware for the same reason).  From
the late 90s through the early/mid 2000s creating a RAID 10 with either the
Mylex or AMI RAID firmware was a single step process.  However, back then, they
didn't offer any "hybrid" RAID levels other than 10--no RAID 50/51 etc.

> Reading through the SNIA document and noting IBM & LSI's involvement
> made me think they may be using the DDF specs in their arrays, which
> might explain why setting up a RAID 10 array was such an involved
> affair.

I doubt this has anything to do with SNIA.  Now that they offer multiple hybrid
RAID levels, which all basically all nested stripes, they've created a multi
step process that covers all cases, instead of individual separate code to cover
each case.

-- 
Stan
