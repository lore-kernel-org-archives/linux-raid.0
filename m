From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Read algorithm-raid1/raid10
Date: Tue, 18 Jan 2011 12:00:49 -0200
Message-ID: <AANLkTi=ULecH9g9Mt+axPY_KsyvZU=KdawphxpJ2kDGi@mail.gmail.com>
References: <AANLkTin+Kd+RfuEUyBrvnunBbQ+2uzzdy57Xy-LEJ_6J@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin+Kd+RfuEUyBrvnunBbQ+2uzzdy57Xy-LEJ_6J@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

like this patch (a long time ago)
http://www.spinics.net/lists/raid/msg30003.html


2011/1/18 Roberto Spadim <roberto@spadim.com.br>:
> hi guys, could we implement a load_balance read algorithm for SSD?
> nearest head isn't as fast as round robin for ssd.
> i'm talking about raid1 (raid10 too)
> what's my problem?
> as i can see, raid0 is faster than raid1
> for example:
> two disks raid0 is faster than
> two disks raid1.
>
> why?
> nearest head
> instead of a balanced read algorithm (like raid0) the nearest head
> make raid1 use only one disk for searchs where we could use two disks
> (like raid0)
>
> could we implement a round robin for ssd? and make raid1 as fast as
> raid0 for ssd?
> i didn't tested the raid10 algorithm yet.
> thanks a lot.
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>



-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
