From: Boniforti Flavio <boniforti@provincia.verbania.it>
Subject: Re: Software RAID-1: step-by-step help needed...
Date: Tue, 10 Aug 2004 11:18:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <411892D0.8050701@provincia.verbania.it>
References: <41188A95.5000608@provincia.verbania.it> <Pine.LNX.4.56.0408100948230.1665@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0408100948230.1665@lion.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Gordon Henderson wrote:

> You can do either. Personally, I create identical partitions on each drive
> and then mirror them.

OK. What would be the difference (in terms of performance and/or ease of 
configuration/maintenance) between the two methods?

> Probably the easiest way to get started is to pick a distribution that
> lets you build the disks as a mirror from install time - Eg. Red Hat (or
> whatever it's called these days) If you have an existing server with one
> disk and want to add a 2nd as a mirror, thats not too difficult. you need
> to read the stuff in the Software RADI HowTo which has the information on
> how to do it all.

I see, but I *have to* install Debian on it.
I already installed it (as a test) following the instructions found at:
http://www.inittab.de/manuals/debootstrap.html
I guess the hardest task will be configuring RAID, as the system works 
with the above procedure...

> Booting RAID1 with Lilo is easy, I presume you can do it too with grub,
> but I don't use grub.

I'll stick with LiLo because I'm used to use it on other systems.

Regards,
-- 
-----------------------------------
Boniforti Flavio
Provincia del Verbano-Cusio-Ossola
Ufficio Informatica

Tecnoparco del Lago Maggiore
Via dell'Industria, 25
28924 Verbania
-----------------------------------
