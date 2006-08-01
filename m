From: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: let md auto-detect 128+ raid members, fix potential race condition
Date: Mon, 31 Jul 2006 23:20:14 -0300
Message-ID: <oru04xrych.fsf@free.oliva.athome.lsd.ic.unicamp.br>
References: <ork65veg2y.fsf@free.oliva.athome.lsd.ic.unicamp.br>
	<20060730124139.45861b47.akpm@osdl.org>
	<orac6qerr4.fsf@free.oliva.athome.lsd.ic.unicamp.br>
	<17613.16090.470524.736889@cse.unsw.edu.au>
	<ord5blcyg0.fsf@free.oliva.athome.lsd.ic.unicamp.br>
	<44CE7A9B.8020508@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44CE7A9B.8020508@dgreaves.com> (David Greaves's message of "Mon, 31 Jul 2006 22:48:11 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Jul 31, 2006, David Greaves <david@dgreaves.com> wrote:

> Alexandre Oliva wrote:

>> in the initrd image, since then any reconfiguration requires the info
>> to be introduced in the initrd image before the machine goes down.
>> Sometimes, especially in case of disk failures, you just can't do
>> that.

> Your example supports Neil's case - the proposal is to use initrd to run
> mdadm which thne (kinda) does what vgscan does.

If mdadm can indeed scan all partitions to bring up all raid devices
in them, like nash's raidautorun does, great.  I'll give that a try,
since Neil suggested it should already work in the version of mdadm
that I got here.  I didn't get that impression while skimming through
the man page, but upon closer inspection now I see it's all there.
Oops :-)

>> I wouldn't have a problem with that, since then distros would probably
>> switch to a more recommended mechanism that works just as well, i.e.,
>> ideally without requiring initrd-regeneration after reconfigurations
>> such as adding one more raid device to the logical volume group
>> containing the root filesystem.

> That's supported in today's mdadm.

> look at --uuid and --name

--uuid and --name won't help at all.  I'm talking about adding raid
physical volumes to a volume group, which means new uuid and name, so
whatever already is in initrd won't get it.  Neil's-posted command
line should take care of that though.

Even if the root device doesn't use the newly-added physical volume,
initrd's vgscan needs to find *all* physical volumes in the volume
group, otherwise the volume group will be started in `degraded' mode,
i.e., with the missing physical volumes mapped to a device mapper node
that will produce I/O errors on access IIRC, and everything else
read-only, without any way to switch to read-write when the remaining
devices are made available, which is arguably a missing feature in the
LVM subsystem.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Secretary for FSF Latin America        http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
