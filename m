From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Few questions about a raid array with 3 faulty spares
Date: Sun, 23 Dec 2012 11:18:24 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1212231116420.17599@uplift.swm.pp.se>
References: <CAH-e9vJ_WWAL=sabeoJ8ybM0Etbf5bcar1vnGWS9wrWJx=njTQ@mail.gmail.com> <CAH-e9v+YKqVVDpxN6W21fpWOxaNhCs7kr0uKT+33XtN0PUfe-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-137064504-1910787538-1356257904=:17599"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH-e9v+YKqVVDpxN6W21fpWOxaNhCs7kr0uKT+33XtN0PUfe-A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Gar=F0ar_Arnarsson?= <gardar@giraffi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---137064504-1910787538-1356257904=:17599
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Sat, 22 Dec 2012, Garðar Arnarsson wrote:

> I am thinking about moving the disks to other sata ports and then try to 
> get the array running again. My question is what method I should use, 
> force assemble? Re-add? Or something else?

Start by sending mdadm -E for all the drives plus dmesg from when they 
were kicked out. Do not pastebin, just send long email.

Do *not* use mdadm --create --assume-clean or zero any superblocks until 
all other options are exhausted.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
---137064504-1910787538-1356257904=:17599--
