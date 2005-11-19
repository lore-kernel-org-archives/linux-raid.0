From: Mike Hardy <mhardy@h3c.com>
Subject: Re: no reconstruction in 2.6.14.2?
Date: Sat, 19 Nov 2005 13:14:26 -0800
Message-ID: <437F95B2.5050602@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I meant to send this to the list as well, and sent it to just Carlos
instead. Obviously chime in if I'm off base.

-Mike

-------- Original Message --------
Subject: Re: no reconstruction in 2.6.14.2?
Date: Sat, 19 Nov 2005 13:13:11 -0800
From: Mike Hardy <mhardy@h3c.com>
To: Carlos Carvalho <carlos@fisica.ufpr.br>
References: <17279.33939.476421.616066@fisica.ufpr.br>


One of the things you get with newer kernels is that the md driver more
aggressively marks the array clean, typically very quickly after the
last write was issued.

The benefit is that more often than not even if you shut down
unexpectedly, the arrays are clean and you don't have to resync on startup.

So I think the behavior is expected.

If you were to run bonnie++ against the array, and shut down abruptly,
you would most likely be unclean and get the resync.

-Mike

Carlos Carvalho wrote:
> I've just installed a new server with a 5-disk raid5 and kernel
> 2.6.14.2. To check something I did a hard reset without shutdown and
> on reboot the machine didn't do any automatic resync; all arrays are
> shown clean.
> 
> Is this some automatic intent-logging or another 2.6 feature (the
> machine had been really idle for minutes before the reset)??? This is
> my first 2.6 raid5 and with 2.4 resync does happen...
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

