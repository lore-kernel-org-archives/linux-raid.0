From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: Tecs informations about Software RAID on Linux
Date: Fri, 11 Jul 2003 16:06:20 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0307111558280.2345-100000@multivac.sdsc.edu>
References: <20030711202626.19448.qmail@web13706.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030711202626.19448.qmail@web13706.mail.yahoo.com>
To: =?iso-8859-1?q?Leonardo=20Dias?= <leoadias@yahoo.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leonardo,

> Where can I find tecs informations about Software RAID
> on Linux. I need to know how RAID stores blocks on
> discks and how parity is granted.
>
> Where can I find it???

I have a small web page that describes the relative location of RAID
segments in a RAID-5 array, for the four different Linux RAID-5 algorithms
(right/left synchronous/asynchronous).

http://www.accs.com/p_and_p/RAID/LinuxRAID.html

Some information on how the parity is maintained is on a related page I
have.  This information is in the RAID-4 section, but the parity
generation is the same for RAID-4 and RAID-5.

http://www.accs.com/p_and_p/RAID/BasicRAID.html

That's two pieces of the puzzle.  Is that enough?

Good luck.
				Peter Ashford

