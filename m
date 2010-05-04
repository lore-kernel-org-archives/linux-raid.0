From: Drew <drew.kay@gmail.com>
Subject: Re: Compatible Hardware Controllers (Smartctl, 8 port, SFF-8087)
Date: Tue, 4 May 2010 12:09:41 -0700
Message-ID: <z2yc268e4661005041209v95f82e8eo3b59cee8c5b43687@mail.gmail.com>
References: <g2mbfcaab951005041145y88e4b350le3e6e2a691160231@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <g2mbfcaab951005041145y88e4b350le3e6e2a691160231@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn.dod@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The problem with this controller is that if you try to use smartctl or
> smartd to monitor your drives, the controller will become unresponsive
> and offline an arbitrary amount of drives. This causes a huge problem
> in raid because then the drives get marked as failed and I have to
> force add them back into the array.

This is a known issue with the 1068 series which AFAIK there are some
patches floating around that resolve this issue. Refer to
https://bugzilla.kernel.org/show_bug.cgi?id=14831 for particulars.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
