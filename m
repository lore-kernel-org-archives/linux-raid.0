From: Denis Golovan <denis.golovan@gmail.com>
Subject: Re: RAID5 hard freeze
Date: Wed, 5 Mar 2014 23:12:47 +0200
Message-ID: <CAF8FvywD2vNNPSMcDmxM64FnY-LR-sHRbdOJS7shHd8OMYCOLw@mail.gmail.com>
References: <CAF8Fvyz2PnEd=t=E-xUuG6anoLhm1zJCn0txD=P_aE_5AmoVUw@mail.gmail.com>
	<20140225135809.0b1afc69@notabene.brown>
	<CAF8Fvyy3DqXZPx83Bk1bTgws5W0Z9Zm-XkE86En9uJk886zERg@mail.gmail.com>
	<CAF8FvyxaXNHEAqdsfGfF-j_di9W=a5Mx3GwOFyoA_NHea-x+5g@mail.gmail.com>
	<5315BF94.50803@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5315BF94.50803@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2014-03-04 13:57 GMT+02:00 Bernd Schubert <bernd.schubert@fastmail.fm>:

> But why should it be RAID/filesystem and not hardware related or another
> linux subsystem?
>

No idea. It's just my impression.
Direct (using dd utility) access to RAID array does not lead to freezes.
Reconstruction never fails too.

>>
>> I would still like to debug the problem.
>> Please help.
>
>
> The only way to get more help and information is probably to attach a real
> serial console (i.e. ipmi-sol).

Does it work when hard freeze happens?
I'd like to read some howto on how to debug issues like that.

BR,
Denis
