From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: Re: [OT] C programming problem
Date: Wed, 7 Feb 2018 21:00:41 +0100
Message-ID: <20180207200041.GC2136@otheros>
References: <2a2e28ad-20bd-d369-d65f-19d79f1871fb@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2a2e28ad-20bd-d369-d65f-19d79f1871fb@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wol's lists <antlists@youngman.org.uk>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Feb 07, 2018 at 07:46:13PM +0000, Wol's lists wrote:
> It is for raid, honest :-)
> 
> My C is so rusty it's jammed solid :-) but I'm trying to prototype a simple
> algorithm for "de-clustering" a raid-60/61 array.
> 
> Googling for my error -
> 
> main.c:20:5: warning: incompatible implicit declaration of built-in function
> ‘memset’ [enabled by default]
>      memset( &array, 0, blocks * sizeof(int) );
> 
> says "you need to include stdlib.h" - but I have!

You need to include string.h. See "man memset" (if your distro
has those).

I tried your code and I didn't get a warning or error for
malloc(). stdlib.h should be fine for malloc().
