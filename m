From: "Jeff Breidenbach" <jeff@jab.org>
Subject: transferring RAID-1 drives via sneakernet
Date: Mon, 11 Feb 2008 16:59:44 -0800
Message-ID: <e03b90ae0802111659v2889dc52kc6eed9dfc9478f9e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm planning to take some RAID-1 drives out of an old machine
and plop them into a new machine. Hoping that mdadm assemble
will magically work. There's no reason it shouldn't work. Right?

old  [ mdadm v1.9.0 / kernel 2.6.17 / Debian Etch / x86-64 ]
new [ mdad v2.6.2 / kernel 2.6.22 / Ubuntu 7.10 server ]
