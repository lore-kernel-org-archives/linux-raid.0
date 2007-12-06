From: "Jon Nelson" <jnelson@jamponi.net>
Subject: Re: Reading takes 100% precedence over writes for mdadm+raid5?
Date: Wed, 5 Dec 2007 19:27:28 -0600
Message-ID: <cccedfc60712051727u4164b488o820509087f46cbcd@mail.gmail.com>
References: <Pine.LNX.4.64.0712021807260.10289@p34.internal.lan>
	 <18259.15708.870492.17273@notabene.brown>
	 <Pine.LNX.4.64.0712021821290.13428@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712021821290.13428@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I saw something really similar while moving some very large (300MB to
4GB) files.
I was really surprised to see actual disk I/O (as measured by dstat)
be really horrible.

-- 
Jon
