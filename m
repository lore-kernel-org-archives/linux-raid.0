From: Tim Small <tim@buttersideup.com>
Subject: Re: mdadm: failed devices become spares!
Date: Mon, 17 May 2010 22:09:45 +0100
Message-ID: <4BF1B099.9040400@buttersideup.com>
References: <9D.D3.23029.CDD40FB4@cdptpa-omtalb.mail.rr.com> <201005172010.36157.pierre@vigneras.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201005172010.36157.pierre@vigneras.name>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Pierre_Vign=E9ras?= <pierre@vigneras.name>
Cc: Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org, 578352@bugs.debian.org
List-Id: linux-raid.ids

Pierre Vign=E9ras wrote:
> And the next question is: how to activate those 2 spare drives? I was=
=20
> expecting mdadm to use them automagically.
>  =20

If you want to experiment with different ways of getting the data back,
but without risking writing anything to the drives, you could do this:

1. Use dmsetup to create copy-on-write "virtual drives" which
"see-through" to the content of your real drives, but don't risk writin=
g
anything at all to them.

2. Use mdadm --create --assume-clean ...blahblah...
/dev/mapper/cow_drive_1  .....

to force mdadm to put the array back together the way you think it was
(the output of examine will be useful here).  You'll need to specify (a=
t
least - from memory):

=2E stripe size
=2E metadata version (this affects metadata location on the drives)
=2E correct device order (with or without a single failed drive)


=2E.. after that you can run a read-only (or read-write) check on the C=
OW
md partition to verify that you've got your data back, then mount it
read-only etc.  Once you're happy that your commands are going to get
things running again, you can run them "for real" on the non-COW device=
s.

See the recent list archives for my post on using a similar set of
commands for HW RAID data forensics, along with references....

HTH,

Tim.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
