From: "Andris Berzins" <pkix@inbox.lv>
Subject: Re: Western Digital Green 3TB SATA3 experiences
Date: Wed, 20 Mar 2013 11:21:32 +0200
Message-ID: <1363771292.51497f9ca4fb5@mail.inbox.lv>
References: <1363766982.51496ec6ea41f@mail.inbox.lv>
 <20130320144805.15140c70@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130320144805.15140c70@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting "Roman Mamedov" <rm@romanrm.ru>:
> On Wed, 20 Mar 2013 10:09:42 +0200
> "Andris Berzins" <pkix@inbox.lv> wrote:
> 
>> I am running RAID5 array on 6x 3TB WD SATA disks.
>> I have problems with all of these disks (including replaced one).
>> Disks are being randomly kicked out from array and SMART shows
>> pending sectors which usually can be fixed by read-write or write to that se
>>ctor.
> 
> Perhaps you have a problem with something other than the drives, e.g.:
> 
> - a bad or insufficient PSU, providing too low (or too high) voltage over 5V
> or 12V (this could manifest only under load, too);

I have bought 550W PSU specially for this. The server is connected through APC UPS.

> - not enough cooling?

Putting a hand temperature seems lightly warm.


> - inadequate case, resulting in overly high vibration or even resonance?

Well, the case is average workstation case.


>> Has anyone experienced something similar with WD green series?
> 
> If you see a sectors repeatedly appearing that become unreadable but are fix
>ed
> after a write, it is usually a symptom of a drive that is partially defectiv
>e
> and should be exchanged.

That one which I exchanged worked for 3 month without problems.

> 
> But since you have this symptom with all of them, maybe the cause is differe
>nt.
> 
> 
>> Is this because of WD "green" series?
> 
> No.

"Green" series are special because they spin down after 7 seconds and they do not
return in timely manner when read error occurs.


> 
> --
> With respect,
> Roman

