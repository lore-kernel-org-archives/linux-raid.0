From: Igor Podlesny <for.poige+linux@gmail.com>
Subject: Re: man mdadm regarding --assume-clean says it's OK to use with RAID1
	or 10, when creating:
Date: Sun, 23 Aug 2009 13:21:49 +0800
Message-ID: <43d009740908222221w5f5ae3b4qa224322ce0e763c6@mail.gmail.com>
References: <43d009740908220701j25b26bd8o4ac0030121544c32@mail.gmail.com>
	<c268e4660908221046x6e461de1u3c6e36f1a7e4021c@mail.gmail.com>
	<43d009740908221048w2b76f14fwae6abdec1b098bcf@mail.gmail.com>
	<b5c57585f8e55bf526f86418980dfbb4.squirrel@neil.brown.name>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b5c57585f8e55bf526f86418980dfbb4.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Drew <drew.kay@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/8/23 NeilBrown <neilb@suse.de>:
[...]
> Yes it will be updated. =C2=A0But if it is updated with a
> read-modify-write cycle then an old incorrect value will be updated
> to a new incorrect value, which doesn't help you much.

	I see. Thank you for the answer. My assumption was due thinking that
parity is never being used when RAID5 is in "healthy" mode.
=09
	But anyway, please clear it up: if I've made --asume-clean RAID5
array, formatted it with some FS (or even LVM), and put OS/data to it,
then (in idle at night, for e. g.) run "resync", would that be the
same valid result (overall data integrity) as if I had previously
created it without "--asume-clean" at all? (Let's suppose hard disks
were healthy in both cases :-)

	And Neil, using the chance to have your reply :-) I'd like to ask one
more question: is that true (I think and hope it is!) that MD doesn't
read/write full chunk size when it's just to read/write another block
of data and hence chunk size only affects data interleaving on disks.
=09
	P. S. Is there someone on this list who can share his linux-RAID
archive in mbox format? From time to time I find interesting
discussions have been going but can't just hit "Reply". If you can
help me with that, please reply personally (not CC:ing to the list).
Thanks!

--=20
End of message. Next message?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
