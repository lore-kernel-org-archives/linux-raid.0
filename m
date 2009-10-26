From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [Fwd: Re: BUG: soft lockup - CPU#0 stuck for 10s!
	[md2_raid1:358]]
Date: Mon, 26 Oct 2009 10:28:49 -0700
Message-ID: <e9c3a7c20910261028x320c4147yced8cc5774a8786f@mail.gmail.com>
References: <4ADEFFC9.10405@shiftmail.org> <4ADFD13E.90900@howardsilvan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ADFD13E.90900@howardsilvan.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lee Howard <faxguy@howardsilvan.com>
Cc: Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Oct 21, 2009 at 8:27 PM, Lee Howard <faxguy@howardsilvan.com> w=
rote:
> I'm not sure that I was doing it the *right* way, but go to:
>
> http://git.kernel.org/
>
> Click on "md raid development
> <http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/md.git;a=3Dsummary>=
". =A0Then if
> you look at the bottom for "master" head you'll go to this link:
>
> http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/md.git;a=3Dshortlog;=
h=3Drefs/heads/master
>
> Then click on "tree" (
> http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/md.git;a=3Dtree;h=3D=
refs/heads/master;hb=3Drefs/heads/master
> ) to browse the repository tree. =A0Dig a little further, and go to d=
rivers/md
> and you can see the change history in the various files to see if a p=
atch
> has been applied.
>
> Maybe that's the wrong way to do it, but that's how I was looking.
>

Hi Lee,

This my development tree that feeds into Neil's official tree which is
maintained here:

http://neil.brown.name/git?p=3Dmd;a=3Dsummary

So, look there if you want to see the official md patches heading
towards Linus.  Note that the stuff in my tree may get rebased and
reordered due to review feedback from Neil and other Linux RAID
developers.  Same goes for Neil's "for-next" branch if I am not
mistaken.

Regards,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
