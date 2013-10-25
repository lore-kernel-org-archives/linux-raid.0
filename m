From: <yuji_touya@yokogawa-digital.com>
Subject: RE: Help raid10 recovery from 2 disks removed
Date: Fri, 25 Oct 2013 10:08:57 +0000
Message-ID: <1F36A02C60ACD1478457DCD917DA0FA8034C9E@ZEX001-0M9030.jp.ykgw.net>
References: <1F36A02C60ACD1478457DCD917DA0FA8034656@ZEX001-0M9030.jp.ykgw.net>
 <1F36A02C60ACD1478457DCD917DA0FA8034983@ZEX001-0M9030.jp.ykgw.net>
 <alpine.DEB.2.02.1310241441280.1838@uplift.swm.pp.se>
 <2614300.keHkAfZ48K@eseries.newtech.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2614300.keHkAfZ48K@eseries.newtech.fi>
Content-Language: ja-JP
Sender: linux-raid-owner@vger.kernel.org
To: dag@newtech.fi, swmike@swm.pp.se
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dag,

> Just had a fight with this myself, also using Seagate drives.
> And I don't think he needs to loose any data, nor use ddrescue here.

What a coincidence! thank you for your advice.
But sorry, dd_rescue is now running on my PC. (Thank you Mikael)
Looking at the progress, it will take about 12 hours more to finish copying.

To move the 112 "Pending" sectors to "Reallocated_Sector_Ct" in sdb, redundancy
drive is required? I don't know whether it works or not in my case.

>> Also check why you didn't get notification that sdc wasn't part of the
>> array, usually mdmon or equivalent will send email about these events.
>
> Good advice! Set up the smartctl email address!

Not mdadm.conf but smartctl?
I added "MAILADDR" entry (mailing list in my dept.) to /etc/mdadm.conf, and
mdmonitor service was running. But no notifier e-mail was delivered to the list.
There is a mail server issue in my company. :(
Anyway now I set my personal e-mail address to MAILADDR and found notifier works.

Thanks
Yuji

-----
CONFIDENTIAL: This e-mail may contain information that is confidential or otherwise protected from disclosure and intended only for the party to whom it is addressed. If you are not the intended recipient, please notify the sender by return and delete this e-mail. You are hereby formally advised that any unauthorized use, disclosure or copying of this email is strictly prohibited and may be unlawful.
