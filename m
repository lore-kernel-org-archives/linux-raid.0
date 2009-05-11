From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 11 May 2009 16:47:35 +1000
Message-ID: <18951.51719.756364.632799@notabene.brown>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com>
	<cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com>
	<18899.61151.445765.360191@notabene.brown>
	<51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com>
	<18919.64597.426128.498393@notabene.brown>
	<D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
	<18924.8917.420265.477921@notabene.brown>
	<DA9036B3-2702-4783-92A5-3C46698F1CB3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Monday April 20
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday April 20, dledford@redhat.com wrote:
> 
> IMO, with my name selection patch, with the option to list an array as  
> ignore, and with the option to turn either assembly or incremental  
> modes completely off as I suggested, done in combination with a boot  
> sequence like we now use in Fedora, you have this problem solved.

I've thought a lot about all that you have said, and made some
changes, and hopefully have something that we can all be happy with.

As you may have notices, I just released 3.0-rc1.  Maybe that is a
little optimistic as I haven't sought any feedback concerning my
recent changes, but I really want 3.0 out soon...

I have added the option of putting
  HOMEHOST <ignore>

in mdadm.conf which does - I think - essentially what you want for
Fedora.

It tells mdadm not to put much weight on the 'homehost', but to
instead look to mdadm.conf to be as authoritative as necessary.

So if a name is in use in mdadm.conf, then no other array will get
that name.  But if a name is not in use in mdadm.conf, then it is
available on a first-come, first-served basis.

There are a bunch of other bug fixes in there too.

Please try it out and let me know if you find it usable.

Thanks,
NeilBrown
