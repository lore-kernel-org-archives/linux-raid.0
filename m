From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Subject: [001/002 ] raid0 reshape
Date: Mon, 25 May 2009 14:19:50 +0200
Message-ID: <87r5ydqsrd.fsf@frosties.localdomain>
References: <1241300764.5607.36.camel@raz>
	<e9c3a7c20905191109s92db696ue31a20b0816a4aed@mail.gmail.com>
	<18965.16276.485692.812516@notabene.brown>
	<87f94c370905211220n4e686a30ke452a56a2690d22b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370905211220n4e686a30ke452a56a2690d22b@mail.gmail.com>
	(Greg Freemyer's message of "Thu, 21 May 2009 15:20:42 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>, raz ben yehuda <raziebe@013.net>, linux-raid@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

Greg Freemyer <greg.freemyer@gmail.com> writes:

> ==> What I mean by raid equivalent levels
>
> More and more arrays allow the user to simply say "give me a 100 GB
> logical volume with Raid 5 equivalent protection.  The array then
> looks at the drives it has available and puts together the necessary
> pieces.  As drives are added, removed it moves the data around under
> its own control, but maintains the raid equivalent protection.
>
> Especially when working with dozens of drives and lots of logical
> volumes it makes life much easier.  Admittedly it may come at a cost
> of not being able to specify raid levels with the specificity that
> mdraid currently allows.
>
> ==>
>
> The reason I ask if this is the goal is that doing so may factor into
> decisions about how reshaping is implemented.
>
> Greg

That really seems to scream for LVM to support more raid levels. It
already has linear, raid0 and raid1 support (although I have no idea
how device mapper raid1 compares to md raid1).

Those should be fleshed out more and also support raid 4/5/6 for what
you ask.

MfG
        Goswin
