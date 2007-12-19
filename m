From: "Jon Nelson" <jnelson@jamponi.net>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Wed, 19 Dec 2007 09:06:10 -0600
Message-ID: <cccedfc60712190706w7f9131c3g79dffbb0a4e2fe86@mail.gmail.com>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan>
	 <Pine.GSO.4.64.0712191558290.1549@montezuma.acc.umu.se>
	 <Pine.LNX.4.64.0712191002580.2468@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712191002580.2468@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Mattias Wadenstein <maswan@acc.umu.se>, linux-raid@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids

On 12/19/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Wed, 19 Dec 2007, Mattias Wadenstein wrote:
> >> From that setup it seems simple, scrap the partition table and use the
> > disk device for raid. This is what we do for all data storage disks (hw raid)
> > and sw raid members.
> >
> > /Mattias Wadenstein
> >
>
> Is there any downside to doing that?  I remember when I had to take my

There is one (just pointed out to me yesterday): having the partition
and having it labeled as raid makes identification quite a bit easier
for humans and software, too.

-- 
Jon
