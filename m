From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Tue, 04 Feb 2014 20:19:27 -0500
Message-ID: <52F1919F.2080607@ubuntu.com>
References: <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com> <52EABA63.2060701@ubuntu.com> <52ED77A3.6020509@hardwarefreak.com> <52EE9445.2020202@ubuntu.com> <52EF3865.4000106@hardwarefreak.com> <52EFAACE.40906@ubuntu.com> <52F05ECD.5060804@hardwarefreak.com> <52F12A93.50408@SGI.com> <52F12CA0.1030803@ubuntu.com> <52F134D3.20704@hardwarefreak.com> <52F13795.50408@ubuntu.com> <52F13C66.9030200@hardw
 arefreak.com> <52F14AA4.9020402@ubuntu.com> <52F16276.7040802@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F16276.7040802@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, Larry Fenske <LFenske@SGI.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 02/04/2014 04:58 PM, Stan Hoeppner wrote:
> Yes, I stated that in this post
> 
> http://www.spinics.net/lists/raid/msg45726.html
> 
> in the context of achieving greater throughput with an FIO job
> file configured to use O_DIRECT, a job file I created, that the OP
> was using for testing.  That job file is quoted further down in
> this same post, and is included in my posts prior this one in the
> thread.  Apparently you ignored them.  The context of my comment
> above is clearly established multiple times earlier in the thread.
> 
> In my paragraph directly preceding the statement you quote above,
> I stated this:
> 
> "Serial submission typically doesn't reach peak throughput...  You 
> usually must submit asynchronously or in parallel to reach maximum 
> throughput."
> 
> And again this is in the context of the FIO job file using
> O_DIRECT, and this statement is factual.  As I repeated earlier
> today, O_DIRECT is used because measuring actual throughput at the
> disks is straightforward.  To increase O_DIRECT write throughput in
> FIO, you typically need parallel submission or AIO.  This is well
> known.

Ahh, I did not gather that O_DIRECT was already assumed.  In that
case, then I was simply restating the same thing: that you want aio
with O_DIRECT, but otherwise, buffered IO works fine too ( which is
what the OP was using with dd, which is why it sounded like you were
saying not to do that, that you must use O_DIRECT + aio because
buffered IO won't get you the performance you're looking for ).


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJS8ZGfAAoJEI5FoCIzSKrw43gH/2sUIEVB97YOGpTj5H8XkySb
wJAQxU//LyZRcUiK37TNeIF+6QUfqVtD/VFYxjTFfV8gmLSmu7JzwfMZQjJ2Rrb5
I08Pks2xCrU/XvfLKqum5JQHreJaz8jQQVIByXAziDAj+H46k5NV34rUNDP5glyk
18uKN1ty0//jyKNlzWhRZllw7Uo7CAvJvfTHSxvoTGgTmzeea2Q6eADIv0Ov96Lb
ZeNKnZXTwDyIXskEduDToWQdGL01TYSKXiV8zTqnhMsMBUZ33oE7r5l+a/o/m6Kv
ZKWE+JG/5xzZiFipNj1ELYuPwM/SD6cCPBRfwh2tWmKTG3Z/waD+kjytIwieUDY=
=1T19
-----END PGP SIGNATURE-----
