From: Gordon Henderson <gordon@drogon.net>
Subject: Re: It is safe to stop Raid being reshaped
Date: Wed, 28 Dec 2011 18:15:50 +0000 (GMT)
Message-ID: <alpine.DEB.2.00.1112281810440.10295@unicorn.drogon.net>
References: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="180569313-1976608233-1325096151=:10295"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--180569313-1976608233-1325096151=:10295
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 28 Dec 2011, Jeremy Thompson wrote:

> I was dumb and stacked them pretty close to each other and before
> since they were not under heavy use, there were no problems... however
> now that the drives are under heavy use... I am seeing these errors
> come up. I'd like to re-arrange the drives so they have more airflow
> and also help try and prevent the errors from showing.  So with that
> in mind, would it be at all possible to stop the reshaping process,
> re-arrange the drives, then get the reshaping process back up and
> running?

I'm not 100% sure about stopping the reshape, however I can tell you how 
to check the drive temperatures, if you've not already done this.

Use the hddtemp program.

e.g.

   # hddtemp /dev/sd{a,b}
   /dev/sda: SAMSUNG HD204UI: 25°C
   /dev/sdb: SAMSUNG HD204UI: 22°C

Then check the temperatures against the manufacturers recomendations.

IF you don't have hddtemp in your distro, try smartctl and look for 
parameter 194.

   # smartctl -a /dev/sda | fgrep 194
   194 Temperature_Celsius     0x0002   064   064   000    Old_age   Always       -       23 (Lifetime Min/Max 17/27)

However if you're seeing errors, then who knows... Cabling, motherboard, 
etc. are all possible culprits as well as physical surface defects... You
can find out more with smartctl -

   # smartctl -a /dev/sda

and so on.

Gordon
--180569313-1976608233-1325096151=:10295--
