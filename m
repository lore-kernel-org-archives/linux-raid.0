From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: Raid 5 and Power Failure
Date: Sat, 13 Jul 2002 12:01:22 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4D618F6493CE064A844A5D496733D66704DE77@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Neil Brown <neilb@cse.unsw.edu.au>, Jason Pfingstmann <stclists@wearesimply.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil, Jason

> Get mdadm
>   http://www.cse.unsw.edu.au/~neilb/source/mdadm/
> 
> and use
>   mdadm --assemble --force /dev/md0 /dev/hd......

shouldn't /dev/hda be left out of the list here? since it looks like hda
really is out out date I think you'd get best results by using only the most
up-to-date disks.

Also, when using the mkraid -force method that had to be used before mdadm, I
always recommended leaving out all spare disks and one of the data disks,
forcing the array to be (re)created in degraded mode. that way, write
operations to the disks are kept to a minimum and it's possible to retry if
you made an error (wrong disk left out etc).

would it make sense to treat mdadm similarely, i.e only provide enough
devices to assemble a degraded array and hotadd the final device after the
array checks out ok? I don't like the idea of background parity rebuild
kicking in before I've had a chance to check things out.

Bye, Martin
