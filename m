From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: raid-0 with mdadm vs lvm striping
Date: Wed, 12 Aug 2009 10:41:46 +0200
Message-ID: <87vdkt4e5x.fsf@frosties.localdomain>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B2E99EDBB63@SE-EX008.groupinfra.com>
	<c268e4660908111435x81d080fva423c5ea78605fc2@mail.gmail.com>
	<3ECBDC05781B3D48ABD520A01ABF2F9B2E9A0485D5@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A0485D5@SE-EX008.groupinfra.com>
	(Andrew Henry's message of "Wed, 12 Aug 2009 08:55:01 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: "Henry, Andrew" <andrew.henry@logica.com>
Cc: Drew <drew.kay@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Henry, Andrew" <andrew.henry@logica.com> writes:

>> If you run LVM on top of raid you can have both. :-) All my servers
>> run this config and it makes things easy to move around as needed, in
>> fact a couple of times it saved my data (and my bacon). And with newer
>> versions of mdadm, you can create some interesting raid configs that
>> LVM has no chance of creating.
>> 
>> So why striping? Aside from faster speeds, raid-0 is anything but redundant.
>> --
>> Drew
>
> I need the speed, pure and simple.  It's going to be used as a scratch volume.  I already have a mirrored raid array with mdadm for my "real" data and backups, but I need something faster just to store temporary files on.
>
> --andrew

But why raid0 instead of striped lvm? Does that make a difference in
speed?

MfG
        Goswin
