From: Sujit Karataparambil <sjt.kar@gmail.com>
Subject: Re: [PATCH] md linear: Protecting mddev with rcu locks to avoid races
	in
Date: Wed, 17 Jun 2009 15:07:54 +0530
Message-ID: <921ca19c0906170237o79ba438dpbcaf00c9a4ab56b@mail.gmail.com>
References: <37d33d830906060824u1bf71f1ej22efc3e8bbcaf2b9@mail.gmail.com>
	 <18997.32786.206008.486995@notabene.brown>
	 <37d33d830906162335j2dda043dn7e5c19d3b40de103@mail.gmail.com>
	 <37d33d830906162346m725af61bg5356e2081f05ce74@mail.gmail.com>
	 <921ca19c0906170102s2928dbbeqb76fc933f2ee60f7@mail.gmail.com>
	 <37d33d830906170148l74d95cd9g90738dfd278361c7@mail.gmail.com>
	 <921ca19c0906170214i2c70c2ebg7f59d525d9ba6307@mail.gmail.com>
	 <37d33d830906170232s75421f5as2e6bbd9db1fe10ac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830906170232s75421f5as2e6bbd9db1fe10ac@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry what your patch claims is that the raid array can change the number of
array's otherwise there is no need for an rcu.

> What makes you think that md is static when you array itself can grow.
> md contains information pertaining to the array it holds.

This is what I saying my the md is built statically on top of the raid.

-- 
-- Sujit K M
