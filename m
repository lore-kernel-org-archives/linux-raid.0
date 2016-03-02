From: Another Sillyname <anothersname@googlemail.com>
Subject: Fwd: RAID6 Array crash during reshape.....now will not re-assemble.
Date: Wed, 2 Mar 2016 13:42:46 +0000
Message-ID: <CAOS+5GEfQ2p0xguguKC3uXW8GYBDCxt2vk=-Ci6+nTKwkcWtdQ@mail.gmail.com>
References: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
	<56D6E883.50801@youngman.org.uk>
	<CAOS+5GHof=F94x58SKqFojV26hGpDSLF85dFfm8Xc6M43sN6jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GHof=F94x58SKqFojV26hGpDSLF85dFfm8Xc6M43sN6jA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Kernel is latest Fedora x86_64 4.3.5-300, can't get too much newer
then that (latest is 4.4.x), mdadm is 3.3.4-2.

I agree that the data is likely still intact, doesn't stop me being
nervous till I see it though!!



On 2 March 2016 at 13:20, Wols Lists <antlists@youngman.org.uk> wrote:
> On 02/03/16 03:46, Another Sillyname wrote:
>> Any help and guidance would be appreciated, the drives showing clean
>> gives me comfort that the data is likely intact and complete (crossed
>> fingers) however I can't re-assemble the array as I keep getting the
>> 'critical information for reshape, sorry' warning.
>>
>> Help???
>
> Someone else will chip in what to do, but this doesn't seem alarming at
> all. Reshapes stuck at zero is a recent bug, but all the data is
> probably safe and sound.
>
> Wait for one of the experts to chip in what to do, but you might find
> mdadm --resume --invalid-backup will get it going again.
>
> Otherwise it's likely to be an "upgrade your kernel and mdadm" job ...
>
> Cheers,
> Wol
