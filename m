From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: Auto replace disk
Date: Wed, 8 Mar 2017 22:32:13 +0100
Message-ID: <CAJH6TXjjjnQ3_OJ87Gv8Spsd=7BZ7RGrfCJ0kqeRXTQN_1Q3KQ@mail.gmail.com>
References: <CAJH6TXgyOEE5A8TZVZy-db+tPD1QeHtnXXO3B-1vmKe4cAt6xA@mail.gmail.com>
 <58C04AC9.9070801@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58C04AC9.9070801@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-03-08 19:17 GMT+01:00 Wols Lists <antlists@youngman.org.uk>:
> Do you mean you remove an old disk, and put a new blank disk in?

Yes

> If that's what you mean, then no, it's not possible. mdadm doesn't have
> a clue about disks, what it sees is "block devices".

Ok but mdadm.conf man page seems to say the opposite:
https://linux.die.net/man/5/mdadm.conf

"POLICY
This is used to specify what automatic behavior is allowed on devices
newly appearing in the system and provides a way of marking spares
that can be moved to other arrays as well as the migration domains.

action=include, re-add, spare, spare-same-slot, or force-spare
auto= yes, no, or homehost.

The action item determines the automatic behavior allowed for devices
matching the path and type in the same line. If a device matches
several lines with different actions then the most permissive will
apply. The ordering of policy lines is irrelevant to the end result.

includeallows adding a disk to an array if metadata on that disk
matches that arrayre-addwill include the device in the array if it
appears to be a current member or a member that was recently
removedspareas above and additionally: if the device is bare it can
become a spare if there is any array that it is a candidate for based
on domains and metadata.spare-same-slotas above and additionally if
given slot was used by an array that went degraded recently and the
device plugged in has no metadata then it will be automatically added
to that array (or it's container)force-spareas above and the disk will
become a spare in remaining cases
"

> You should not - if you can help it - ever remove a disk and then
> replace it. Yes in practice I know that's a luxury people often don't
> have ... at best you should have spares configured

If you have a server with only 4 slot configured in a RAID10,
this workflow would be impossible.

> if you have to you
> put the new drive in, use --replace, and then remove the old one. The
> last resort is to remove the broken drive and then replace it - this is
> likely to trigger further failures and bring down the array.

Why ? I've removed many, many, many disks before with no issue.
Why removing a disk should bring the whole array down? This seems a bug to me.
If a disk will crash, the effect is the same as removing from the slot
and RAID is
meant to protect against this kind of failures.
