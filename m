From: Drew <drew.kay@gmail.com>
Subject: Re: Doubt
Date: Mon, 9 Nov 2009 10:35:07 -0800
Message-ID: <c268e4660911091035i77139339rd48941be2c6c06f7@mail.gmail.com>
References: <d3540f4d0911042326o754d5f06qf958d8ab5b309e86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d3540f4d0911042326o754d5f06qf958d8ab5b309e86@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Light King <thelightking@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> So we dont want any kind of data recovery in our raid device (like
> raid0) but we want if one cf card failed also, the raid device should
> run or should reactive without any error(like raid10) but we should
> abel to use the total disk space (like raid0).

I honestly don't think there is any sort of setup that will work as
you described. If you want to have an array continue to function with
missing devices, you *will* have to sacrifice some space. The closest
type of block device I can think of which *might* achieve your goal is
spanning. Basically it turns all four drives into one huge drive but
doesn't stripe across them so *some* data will survive a device
failure.

Even if you were use spanning (assuming mdadm supports it, haven't
looked) and md doesn't complain when the device drops out, the
filesystem will choke as soon as you tried to access the data on the
missing device.

What is the application that needs this configuration?


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
