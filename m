From: "John Stoffel" <john@stoffel.org>
Subject: Re: 3.12: raid-1 mismatch_cnt question
Date: Mon, 11 Nov 2013 16:23:49 -0500
Message-ID: <21121.19173.938188.985528@quad.stoffel.home>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com>
	<527E8B74.70301@shiftmail.org>
	<008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com>
	<527F7FF5.3000002@shiftmail.org>
	<000301cedec0$1fa72d60$5ef58820$@lucidpixels.com>
	<5280BA1E.6060604@shiftmail.org>
	<CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: joystick <joystick@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I thought you could also get a mis-match count from open mmap'd files,
which aren't completely written to one disk or another?  

John
