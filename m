From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: Pending sectors in valid array - how to proceed?
Date: Thu, 29 Jul 2010 10:45:01 +0200
Message-ID: <4C513F8D.5000604@xunil.at>
References: <4C506CF5.2080307@xunil.at>	<4C5079C4.2050308@seoss.co.uk>	<4C5092C4.6050708@gmx.net> <20100729031100.69f583d7@natsu>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100729031100.69f583d7@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: st0ff@npl.de, st0ff@gmx.net, Tim Small <tim@seoss.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 28.07.2010 23:11, schrieb Roman Mamedov:

> That drive is most likely a Seagate, and if so, there's nothing to worry
> about. Literally every Seagate drive will have a high value in
> Hardware_ECC_Recovered, it's just a peculiarity of their SMART. Other vendors'
> drives recover read errors using ECC too, but don't report that into the SMART
> metric.

Yep, it's a Seagate.

All four are Seagate:

sda, sdb: ST3250310NS  (should have ERC as far as I found online)
sdc, sdd: ST3250621NS  (still don't know if they have ERC)

I now decided to run that check-action on all three arrays.

So far it looks good. All three arrays re-synced OK, without any drive
failing. Good :-)

Still no reallocated sectors on all four drives.

"Current_Pending_Sector" and "Offline_Uncorrectable" on /dev/sdb still
at the old value of "13".

Do you think I should swap that drive or not?

(added difficulty: that server is around 400km from me ... I would have
to direct an employee there to swap the hdd ...)

Migrating to RAID6, sure, would make sense, but this would need a
kernel-upgrade and involves quite some work. Right now I have
2.6.25-gentoo-r7 there :-(

thank you all for your replies, Stefan
