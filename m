From: Sujit Karataparambil <sjt.kar@gmail.com>
Subject: Re: [PATCH] md linear: Protecting mddev with rcu locks to avoid races
	in
Date: Wed, 17 Jun 2009 14:44:59 +0530
Message-ID: <921ca19c0906170214i2c70c2ebg7f59d525d9ba6307@mail.gmail.com>
References: <37d33d830906060824u1bf71f1ej22efc3e8bbcaf2b9@mail.gmail.com>
	 <18997.32786.206008.486995@notabene.brown>
	 <37d33d830906162335j2dda043dn7e5c19d3b40de103@mail.gmail.com>
	 <37d33d830906162346m725af61bg5356e2081f05ce74@mail.gmail.com>
	 <921ca19c0906170102s2928dbbeqb76fc933f2ee60f7@mail.gmail.com>
	 <37d33d830906170148l74d95cd9g90738dfd278361c7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830906170148l74d95cd9g90738dfd278361c7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry this was not my question. What I am asking is whether md is built on
top of the raid statically or is it an dynamic part of the raid array.

As with my experiance md is built statically. Your answer

> mddev->raid_disks can change, when you add disks and also in the mean
> while when you are updating the conf, the older conf might be being
> used at various other places.

does not speicify either. It seems to be from manual pages that tries
to administrate
raid array's.
