From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: recover short-time-power-failure of raid 5?
Date: Mon, 25 Nov 2002 11:07:48 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4D618F6493CE064A844A5D496733D6670314F3@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Neil Brown <neilb@cse.unsw.edu.au>, krause@mogli-soft.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi markus,

> I suggest that after assembling the array, you 'fsck' the filesystem
> on md0 just to make sure that the data is fine and then simply hot-add
> the third device:
>   mdadm /dev/md0 -a /dev/sdc
> 
> If fsck reports lots of error..... maybe try force the assmbly from a
> different pair of drives. e.g.
>    mdadm -A --force /dev/sda1 /dev/sdc2
> 
> and then do the fsck.

Oh, and if you try this: DON'T allow fsck to change/fix anything on the disks
if you want to later try a different combination - data corruption is pretty
much guaranteed if you allow any writes and then change to a different set of
disks.

Bye, Martin
PS: not sure what happens if you're using a journaling fs on the raid - I
think fsck replays the journal before checking, so trying out different
combinations of disk doesn't look like a viable option in that case?
