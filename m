From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: max number of devices in raid6 array
Date: Wed, 12 Aug 2009 16:53:13 +0200
Message-ID: <87ab259j8m.fsf@frosties.localdomain>
References: <20090812090600.GF21118@nfs-rbx.ovh.net>
	<55226.78.86.108.203.1250069920.squirrel@www.yuiop.co.uk>
	<20090812121911.GG21118@nfs-rbx.ovh.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090812121911.GG21118@nfs-rbx.ovh.net> (David Cure's message of
	"Wed, 12 Aug 2009 14:19:11 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: David Cure <lnk@cure.nom.fr>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Cure <lnk@cure.nom.fr> writes:

> Le Wed, Aug 12, 2009 at 10:38:40AM +0100, John Robinson ecrivait :
>> 
>> The limit is only with version 0.90 metadata, which is the default. I'd
>> recommend you do a bit of reading to pick metadata version 1.0, 1.1 or
>> 1.2, according to any requirements you may have, then tell mdadm what your
>> choice is with --metadata= while creating your array.
>
> 	thanks for your quick reply, I'm going to read the spec of these
> metadata's version.
>
> 	David.

And compute the overall MTBFS. With how many devices does the MTBFS of
a raid6 drop below that of a single disk?

MfG
        Goswin
