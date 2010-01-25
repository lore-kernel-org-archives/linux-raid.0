From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Thrashing a drive to flush out problems..
Date: Mon, 25 Jan 2010 06:26:46 -0800 (PST)
Message-ID: <77733.15823.qm@web51302.mail.re2.yahoo.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys can anyone recommend a tool for thrashing the b*ll*cks of a drive in  way that isn't destructive to the data?

I was thinking badblocks with -w but it is destructive and i dont want to do anything that will potentially lower the integrity of my array? (Even tho it is raid6 :) )

There must be some bonnie esk tool that will read/write every combination to every block but keep the data safe after to flush out any sector issues etc.

Cheers.


-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its own.'

***********
Please note, I am phasing out jd_hardcastle AT yahoo.com and replacing it with jon AT eHardcastle.com
***********

-----------------------


      
