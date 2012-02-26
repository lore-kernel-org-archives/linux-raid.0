From: NeilBrown <neilb@suse.de>
Subject: Re: md:When opened /proc/mdstat, increase the refcount of
Date: Sun, 26 Feb 2012 22:01:20 +1100
Message-ID: <20120226220120.3dbe3a3b@notabene.brown>
References: <201202261255005786849@gmail.com>
	<201202261633221401738@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/12tMV8rqXY21M3050DYgVYo"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201202261633221401738@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/12tMV8rqXY21M3050DYgVYo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Feb 2012 16:33:25 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> I wrote a letter to maintainer of procfs. He's answer is follow:
> >No.  Read remove_proc_entry(), especially the part under ->pde_unload_lo=
ck.
> >The whole damn point of that stuff is that opened file on procfs does *n=
ot*
> >pin the module down; IO in progress does, but that's it.
> >You can't deadlock rmmod foobar </proc/crap/foobar; with your patch we'll
> >be back to a pile of deadlocks in there.
> >IOW, NAK.

Hmmm... that sounds like Al Viro.

I see the point of that code now.  And your patch would be open to the same
problem wouldn't it. i.e.
    rmmod md_mod < /proc/mdstat

would deadlock??

So we still need to find a fix that actually works correctly.

That probably means moving the call to 'poll_wait' into procfs code, and us=
ing
a wait_queue_head which is managed by procfs.

So maybe:
 - put a wait_queue_head in 'struct proc_dir_entry'
 - have proc_reg_poll call poll_wait passing that wait_queue_head
 - write a function e.g. proc_poll_wake which calls wake_up on that
   wait_queue_head
 - have md.c save the return value from proc_create, and call the above
   function instead of calling "wake_up(&md_event_waiters)"

That should work.

NeilBrown

--Sig_/12tMV8rqXY21M3050DYgVYo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0oRATnsnt1WYoG5AQIeiA//azNbllFGLQKJJgXGAfNsP56Fs3m4z396
1m1cre8tqsaT0IGis/Ynr7poc6THvDkO6BgbXhnKvcNSHLdEHGr0muiy3RHXRn4w
M2BMU+40KYbBwXltd7XKv0yfG1obzDV6nHOtq1swOD4ZME4CwvhEn0lIzokx5WmR
4CfGVT4KkvFXWHYk6rV+LQP6HZTITG0j2al15BWlLV5FDClr7+Yf7C+jDoDI7TpE
OM1Bn0DZwEIGi7EUJLw8KdAbbi6xYpVfBfJK1uruxwsNWvNew9dwJauWcTnBpJ9I
WeQIKssKSgKYMI4zrNqY0JK8+x9NFr+8J+1Z70kqiSZZf08zEr7fB7VXokDR4Iiv
UUKSmFWYaprkkMI9vhnbijaL43sR9QQbG9IrrwVkEIOuMoPEvubroSRmCl7Y6NHz
9PvBbo0o3Nuo+J49HFRtu83qeDuoG5m9wuDpC3Vfx8+xo3fy+c0QtVPtJTDXidGh
0ok8n3FK2viHR/8gESjK11/j3sjctOLrjM3Gd810ZSNLMkL4Gi7bn45WjvYs0zws
2Vl1Qnq2Wee8yXaCSVbMrzoL1U7ZbJlGve7wmhqxC1yOcrEk4R7GYwMmJzisja+c
QJF5UhrDmsNwUmP/zbzXDIgE9pcAB3uH1keAriVOQYc7mKSB13bu3GdUWCERZdRH
Yt5CyV6sBCU=
=/56y
-----END PGP SIGNATURE-----

--Sig_/12tMV8rqXY21M3050DYgVYo--
