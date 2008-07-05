From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
Date: Sat, 5 Jul 2008 12:35:41 -0500
Message-ID: <cccedfc60807051035n943a669q61c01f6f1c05d6fa@mail.gmail.com>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Try booting with:

nolapic

That largely fixed my problems on my motherboard (2.6.18+, EPoX MF-570SLI).
I hope to try 2.6.25+ soon.
-- 
Jon
