From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: How to force stopping an array`
Date: Mon, 26 May 2008 18:06:57 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805261806340.31108@p34.internal.lan>
References: <200805262343.20626.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200805262343.20626.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 26 May 2008, Dexter Filmore wrote:

> So I have a filesystem on an array I cannot unmount, hence I cannot stop the
> array.
> Any way to force it?
>
> Dex

What is using it?

lsof | grep /mount_point
lsof | grep /dev/mdX


