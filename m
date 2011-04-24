From: NeilBrown <neilb@suse.de>
Subject: Re: Server =?UTF-8?B?ZG93bi1mYWls4oCLZWQ=?= RAID5-asking for some
 assistance
Date: Sun, 24 Apr 2011 22:29:18 +1000
Message-ID: <20110424222918.2bde0704@notabene.brown>
References: <BANLkTi=81WTykGQ2TXaf7xGEsL-Gkf+Qrw@mail.gmail.com>
	<ioq2b8$3rl$1@dough.gmane.org>
	<BANLkTim18Sx6JdZO5PiAqnrakDPzy5PNJQ@mail.gmail.com>
	<BANLkTimQXUvU68op8C-W4qPUQzBRzqgP+A@mail.gmail.com>
	<20110422125734.1a68a736@notabene.brown>
	<BANLkTin0SoBzRAear8Jt+26MnVJWouXoNA@mail.gmail.com>
	<20110423074411.78fef94f@notabene.brown>
	<BANLkTik_ZY4uoV3E=ua1p+tUD9g8xqQDVg@mail.gmail.com>
	<20110423184824.55ee7893@notabene.brown>
	<BANLkTi=sCfFFfmZTzj2g8-aDNhDqVK8e-A@mail.gmail.com>
	<20110424075101.6763309f@notabene.brown>
	<BANLkTimDqEWZ6843RvekRGu4Z0XvNLgOwA@mail.gmail.com>
	<20110424125401.3de3720d@notabene.brown>
	<BANLkTi=8P75-wUBq149wiM-=XGVa2HBuvA@mail.gmail.com>
	<20110424184130.1692bce5@notabene.brown>
	<4DB41044.5020404@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DB41044.5020404@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: John Valarti <mdadmuser@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 24 Apr 2011 12:57:56 +0100 John Robinson
<john.robinson@anonymous.org.uk> wrote:

> On 24/04/2011 09:41, NeilBrown wrote:
> > On Sun, 24 Apr 2011 01:06:52 -0600 John Valarti<mdadmuser@gmail.com>  wrote:
> [...]
> >> Here you go. I warn you it is a bit long!
> >
> > Thanks.  Length is no problem.
> >
> > Only it doesn't make sense at all.  I cannot see how mdadm would possibly be
> > generating just those messages.
> > It appear to be rejecting each device for some reason, but it not reporting
> > why it is rejecting the device...
> >
> > What version of mdadm is this?
> >     mdadm --version
> >
> > I should have asked that before.
> 
> I think John said 2.6.9


Ahh, I see it.  This is a bug in there:  ->used isn't set to zero after 'dv'
is allocated.  This was fixed in 3.0.  I don't remember that bug...

I cannot see any easy way to work around that bug.
You could possibly:

  echo DEV /dev/sd[abc]2 > /tmp/mdadm.conf
  mdadm -Eb /dev/sda2 >> /tmp/mdadm.conf
  mdadm -Afvv /dev/md1 -c /tmp/mdadm.conf

I think that would work - but no promises.

 on the CentOS 5.5 rescue media. I think it's 
> time to try something more recent: John, could you try SystemRescueCD 
> from http://www.sysresccd.org/ and run
>    mdadm -Evvs
> and if that shows your RAID5 members again,
>    mdadm -Afvv /dev/md1

Getting a newer mdadm is definitely a good idea.

Safest to explicitly list the devices that you want
     mdadm -Afvv /dev/md1 /dev/sd[abc]2


NeilBrown

> 
> Cheers,
> 
> John.

