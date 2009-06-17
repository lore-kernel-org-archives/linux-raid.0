From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: [PATCH] md linear: Protecting mddev with rcu locks to avoid races
	in
Date: Wed, 17 Jun 2009 15:02:12 +0530
Message-ID: <37d33d830906170232s75421f5as2e6bbd9db1fe10ac@mail.gmail.com>
References: <37d33d830906060824u1bf71f1ej22efc3e8bbcaf2b9@mail.gmail.com>
	 <18997.32786.206008.486995@notabene.brown>
	 <37d33d830906162335j2dda043dn7e5c19d3b40de103@mail.gmail.com>
	 <37d33d830906162346m725af61bg5356e2081f05ce74@mail.gmail.com>
	 <921ca19c0906170102s2928dbbeqb76fc933f2ee60f7@mail.gmail.com>
	 <37d33d830906170148l74d95cd9g90738dfd278361c7@mail.gmail.com>
	 <921ca19c0906170214i2c70c2ebg7f59d525d9ba6307@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <921ca19c0906170214i2c70c2ebg7f59d525d9ba6307@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sujit Karataparambil <sjt.kar@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Sujit,


On Wed, Jun 17, 2009 at 2:44 PM, Sujit Karataparambil<sjt.kar@gmail.com=
> wrote:
> Sorry this was not my question. What I am asking is whether md is bui=
lt on
> top of the raid statically or is it an dynamic part of the raid array=
=2E
>

What makes you think that md is static when you array itself can grow.
md contains information pertaining to the array it holds.


> As with my experiance md is built statically. Your answer
>
>> mddev->raid_disks can change, when you add disks and also in the mea=
n
>> while when you are updating the conf, the older conf might be being
>> used at various other places.
>
> does not speicify either. It seems to be from manual pages that tries
> to administrate
> raid array's.
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
