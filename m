From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md linear: Protecting mddev with rcu locks to avoid races
Date: Thu, 18 Jun 2009 09:38:29 +1000
Message-ID: <19001.32373.993061.631031@notabene.brown>
References: <37d33d830906060824u1bf71f1ej22efc3e8bbcaf2b9@mail.gmail.com>
	<37d33d830906162335j2dda043dn7e5c19d3b40de103@mail.gmail.com>
	<37d33d830906162346m725af61bg5356e2081f05ce74@mail.gmail.com>
	<921ca19c0906170102s2928dbbeqb76fc933f2ee60f7@mail.gmail.com>
	<37d33d830906170148l74d95cd9g90738dfd278361c7@mail.gmail.com>
	<921ca19c0906170214i2c70c2ebg7f59d525d9ba6307@mail.gmail.com>
	<37d33d830906170232s75421f5as2e6bbd9db1fe10ac@mail.gmail.com>
	<921ca19c0906170237o79ba438dpbcaf00c9a4ab56b@mail.gmail.com>
	<19000.48877.539325.500493@notabene.brown>
	<37d33d830906170315k4087d532nc2426879c2063fd7@mail.gmail.com>
	<37d33d830906170317n52afe885y31da8180457fc843@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from SandeepKsinha on Wednesday June 17
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday June 17, sandeepksinha@gmail.com wrote:
> Hi Neil,
> 
> I am attaching the patch file as I am seeing some issues with
> copy-paste into the mail.
> 

Thanks.  Much better.

I possibly didn't explain myself properly when saying that the
rcu_read_lock needed to be taken out side of the call to which_dev.
The reason was that it returns a pointer which still needs to be
protected.  I possibly didn't for the code as it stood, but I wanted
to use call_rcu to free the old conf, so it makes sense to protect the
whole usage of the structure.

So I made that little change.  Then added a patch to free the old conf
with call_rcu.

It is all now pushed out and you can see the final version of this
patch at 

http://neil.brown.name/git?p=md;a=commitdiff;h=af11c397fd8835c70ec0bb777104e4ab98b2d660


Thanks,
NeilBrown
