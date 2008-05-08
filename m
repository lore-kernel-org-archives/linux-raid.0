From: rosenfield.albert@gmail.com
Subject: Re: two questions re. proactive recovery and forced assembly
Date: Thu, 8 May 2008 13:01:40 +0200
Message-ID: <c4985c940805080401k5851a9d5n35d12d6d07ff2496@mail.gmail.com>
References: <c4985c940804100501g5cac252ax129328371c36d397@mail.gmail.com>
	 <48013976.6020705@sauce.co.nz>
	 <c4985c940805070422lfde5f6bhd510c12d2f2d0f2f@mail.gmail.com>
	 <482253C1.5060803@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <482253C1.5060803@sauce.co.nz>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Have a look at the "For assemble"
> section of the mdadm man page.
>
>  mdadm -A --force /dev/mdX /dev/sda1 /dev/sdb1 /dev/sdc1
>
>  does not seem contorted to me.

You're absolutely right.

But will this assemble a RAID5 array where the event counters are out
of sync on not one, but two disks?
