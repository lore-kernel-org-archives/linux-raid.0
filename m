From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 issue after disk failure: both disks of the array are still active
Date: Thu, 13 Sep 2012 14:39:14 -0300
Message-ID: <CABYL=TpKNm9NAnrpdu5GWb-4cAVX24pwY6-1uLn_aGhy+FQL+w@mail.gmail.com>
References: <5051AF17.8010501@linuxsystems.it>
	<20120913103432.GA11764@cthulhu.home.robinhill.me.uk>
	<B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> "check" records errors, no action is taken by the md driver to correct it, although the disk firmware itself may try reallocation. So far, that appears to not be the case.
>
> "repair" causes the md driver to write correct data (from copy or reconstructed from parity), which should force the disk firmware to reallocate the affected LBAs from bad physical sectors to good ones.
>
> It seems in this case "repair" is indicated.
>
Or replace the bad disk =)


-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
