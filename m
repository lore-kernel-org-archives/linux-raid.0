From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Best way (only?) to setup SSD's for using TRIM
Date: Tue, 30 Oct 2012 12:33:27 -0200
Message-ID: <CAH3kUhEEQpw3ZpbBrP3gAkbzvT_gtsX_e8xTC-gpSrmzZM0XUg@mail.gmail.com>
References: <508D808A.7040100@curtronics.com>
	<508FA2C6.2050800@hesbynett.no>
	<508FE44A.3040507@curtronics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508FE44A.3040507@curtronics.com>
Sender: linux-raid-owner@vger.kernel.org
To: Curtis J Blank <curt@curtronics.com>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

a point you should understand (or already understand)
any block is writeable, the garbage collector only mark if that block
is empty or not
empty block just need to be write one time
non empty must be read merged and write (this take more time)

so for speed empty block is faster, but non empty block is fast too...
the other garbage colection function is know how many times block was
write, to predict if it could use that block or a newer
newer can have less problem of loss of information than old blocks,
because ssd have limited write cicles

that's the two main functions of trim... help garbage collection and
'block allocation'
