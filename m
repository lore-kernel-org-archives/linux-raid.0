From: "NeilBrown" <neilb@suse.de>
Subject: Re: a problem with mdadm 2.6.9
Date: Fri, 21 Aug 2009 14:00:23 +1000 (EST)
Message-ID: <edc1d7bf7a3f84919c50b46502e0b164.squirrel@neil.brown.name>
References: <20090821020132421.QHAV6077@cdptpa-omta04.mail.rr.com>
    <d3efa87188ee29c0b3347459276f4faf.squirrel@neil.brown.name>
    <20090821025204000.WAVG29812@cdptpa-omta01.mail.rr.com>
    <ff1870ee87cc6fab6c09c63d7fca56bd.squirrel@neil.brown.name>
    <20090821034131749.XDCC29812@cdptpa-omta01.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090821034131749.XDCC29812@cdptpa-omta01.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: jeffunit <jeff@jeffunit.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, August 21, 2009 1:41 pm, jeffunit wrote:
> I did
> # mdadm -A /dev/md0 /dev/sd[bcdefgh]
>
> mdadm: /dev/md0 assembled from 6 drives - not enough to start the
> array while no
> t clean - consider --force.
>
> Should I use --force ?

Yes, definitely.   I meant to say that, sorry.

>
> I know how to deal with the startup issue, once the array is working.

Great.

NeilBrown

