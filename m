From: Raz <raziebe@gmail.com>
Subject: Re: How to configure 36 disks ?
Date: Mon, 23 Mar 2009 18:32:46 +0200
Message-ID: <5d96567b0903230932j5bf11d88yee16be70759ef73b@mail.gmail.com>
References: <5d96567b0903230659t734677a3pb4fd77cccb54008b@mail.gmail.com>
	 <20090323151257.1c7c0a8e@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090323151257.1c7c0a8e@harpe.intellique.com>
Sender: linux-raid-owner@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 23, 2009 at 4:12 PM, Emmanuel Florac <eflorac@intellique.co=
m> wrote:
> Le Mon, 23 Mar 2009 15:59:47 +0200
> Raz <raziebe@gmail.com> =E9crivait:
>
>> 1. redundancy. fair. less likely three disks will break in a single
>> raid 2. performance. bad.
>> 3. modularity. yes. grows
>> 4. Size 24TB
>
> I don't understand why you'd have a bad performance here. I usually
> notice a very slight difference between LVM and linux-raid raid0 in a=
ll
> practical benchmarks. Did you use LVM striping capability? You may
> have to adjust readahead (using blockdev --setra) on each
> device /dev/dm-X and /dev/md-X) to achieve optimal performance.
Problem i have with performance is that once you *add* to a active
volume a new PE, you lose striping in the sense that you cannot tell
where the IO is directed to ( which disk). My implementation relies on
this fact. If you know I am wrong please correct me.

>
> --
> ----------------------------------------
> Emmanuel Florac =A0 =A0 | =A0 Intellique
> ----------------------------------------
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
