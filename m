From: "NeilBrown" <neilb@suse.de>
Subject: Re: 2 Disks Jumped Out While Reshaping RAID5
Date: Sun, 6 Sep 2009 07:32:37 +1000 (EST)
Message-ID: <a6dfa0829c75cc81fd4482bb344bbff2.squirrel@neil.brown.name>
References: <70ed7c3e0909051322l7cf66158lbbc8a5dd2cc18b8b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909051322l7cf66158lbbc8a5dd2cc18b8b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, September 6, 2009 6:22 am, Majed B. wrote:
> Hello all,
>
> I have posted my problem already here:
> http://ubuntuforums.org/showthread.php?p=3D7900571#post7900571
> It also has file attachments of the output of mdadm -E /dev/sd[a-h]1

It seems that you need to log in to read the attachements... so I haven=
't.

>
> I appreciate any help on this.

Hopefully you just need to add "--force" to the assemble command
and it would all just work.  However I haven't tested that on an array
that is in the process of a reshape so I cannot promise.
I might try to reproduce your situation and with some scratch drives
and check that mdadm -Af does the right thing, but it won't be a day
or so, and as I cannot see the --examine output I might get the
situation a bit wrong ... (hint hint: it is always best to post
full information rather than pointers to it, unless said information is
really really big).

NeilBrown



> --
> =C2=A0 =C2=A0 =C2=A0 Majed B.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
