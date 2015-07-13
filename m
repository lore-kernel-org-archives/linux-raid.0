From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: Resurrecting a Dirty RAID-5
Date: Mon, 13 Jul 2015 08:31:39 +0200
Message-ID: <55A35B4B.9020706@gmail.com>
References: <OFC233BA12.DDED55A2-ON85257E7C.00420655-85257E7C.0043331F@jt-sw.com> <559D2374.7040208@turmel.org> <OF71F1F6CD.C562AA57-ON85257E7D.000FAD79-85257E7D.0010311B@jt-sw.com> <alpine.DEB.2.02.1507120756020.11810@uplift.swm.pp.se> <OF4E023A92.1624DC91-ON85257E80.0051B769-85257E80.005287C5@jt-sw.com> <55A2EB25.10607@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55A2EB25.10607@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/07/15 00:33, Adam Goryachev wrote:
> Also, for your raid1, never have a hot spare, just do this:
> mdadm /dev/mdX --grow --raid-devices=3
> Then you will always have all your data replicated on all three drives,
> so again, no hot spare required.

Never say never, as there are valid use cases for having hot spares in a
RAID1 set.

My own use case is that I want to be reasonably assured that my spare
won't fail at around the same time as the active disks (due to having
the same age and having been subjected to exactly the same workload).
