From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux raid wiki
Date: Fri, 23 Sep 2016 23:38:12 -0400
Message-ID: <b3cb56a8-f754-89e7-dc26-abcde9d78bdd@turmel.org>
References: <57E469E0.4020005@youngman.org.uk>
 <002a01d215c0$e3f20980$abd61c80$@wnsdev.com>
 <57E577BE.8080101@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57E577BE.8080101@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, WNSDEV <pete@wnsdev.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/23/2016 02:43 PM, Wols Lists wrote:
> Thanks.
> 
> My understanding of role numbers is that they are the order of the disks
> in which stripes are written, so role 0 has the first stripe, role 1 the
> second, etc etc.

Yes, this is correct.  But the numbers in brackets in mdstat aren't the
role number, but the slot number in the superblock member list.  Which
only matches role number for the active devices at first creation.
Spares occupy additional slots, and keep their slot number for their
life in the array, including after assuming an active role.

> This is *normally* irrelevant, but should the array ever get trashed,
> the disks need to be listed *in* *that* *order* in a new --create statement.

You must use the "this device" role numbers in an mdadm -E report to be
sure, or use lsdrv.

mdstat is only useful for human review of array status.

Phil

