From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 00:19:29 -0800
Message-ID: <4877c76c0911110019u42b6f664r22c31a8d8c78586@mail.gmail.com>
References: <70ed7c3e0911102122l3565cfat7a35a8a649237f56@mail.gmail.com>
	 <20091111081325702.LZCS6968@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091111081325702.LZCS6968@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

That kind of exception is one of the main areas I think major dists
fail.  Making it so absolutely difficult to insert administratively
know requirements at 'odd' points in the boot order.  When I last used
Debian it was easy with that S## / K## linking system.  Arch is
another dist that has a way of doing that, except it's based in a core
config file.  I like Debian's method more because then you can use
shell scripts to easily slice/dice/add things at given points.  Arch
is more than sufficient for normal tasks though.
