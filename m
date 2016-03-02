From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: RAID6 Array crash during reshape.....now will not re-assemble.
Date: Wed, 2 Mar 2016 13:20:03 +0000
Message-ID: <56D6E883.50801@youngman.org.uk>
References: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/03/16 03:46, Another Sillyname wrote:
> Any help and guidance would be appreciated, the drives showing clean
> gives me comfort that the data is likely intact and complete (crossed
> fingers) however I can't re-assemble the array as I keep getting the
> 'critical information for reshape, sorry' warning.
> 
> Help???

Someone else will chip in what to do, but this doesn't seem alarming at
all. Reshapes stuck at zero is a recent bug, but all the data is
probably safe and sound.

Wait for one of the experts to chip in what to do, but you might find
mdadm --resume --invalid-backup will get it going again.

Otherwise it's likely to be an "upgrade your kernel and mdadm" job ...

Cheers,
Wol
