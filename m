From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: Test program for raid
Date: Thu, 19 Dec 2002 03:46:35 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1021219034027.25632A-100000@Maggie.Linux-Consulting.com>
References: <984305F1827DD5118FEA0000D1105F0A01BDC0B7@HW_MAIL>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <984305F1827DD5118FEA0000D1105F0A01BDC0B7@HW_MAIL>
To: "SCHEP. - Schepke, Arnt" <SCHEP@Hoeft-Wessel.de>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


hi ya

On Thu, 19 Dec 2002, SCHEP. - Schepke, Arnt wrote:

> Hi,
> just a little question: I want to test my Software-RAID1 System.
> I have some errors and want something like a one year usage in a one day
> test.
> 
> Do you have an idea what program to use?

- pull the power cord "now" .... see if the system keeps working

- pull the ide cable to disk ... see if it keeps working and boots in
  degraded mode

- resync everything... 

-- load up your PC with lots of jobs... say an xload of 10 or 50 ...
   and see if the system dies or hangs....
	- not a fair test to renice things either...

- now increase room temperature by 10C ....
	- that should simulate  what would be 10yr lifespan
	and drop it to failur in 5 years
	( whatever the normal lifespan was is cut in 1/2 for
	( every 10C increase in ambient temp

	- you can simulate 4 years of work in 1 year at 20C above normal

- amount of work it does ... your machine will fail long before you
  hit a year's work to be tested in 1 day

- whatever it says is the MTBF on your components... divide that in half
  and that might be your expected lifespan...

- no simple way to do "lifespan tests"
	- other than increase room temp by +10C, +20C, +30C ...

-- just save your data daily to other "offline backup media"
   as you never know when things will die

c ya
alvin


