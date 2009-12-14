From: Matthieu Patou <mat@matws.net>
Subject: Re: Random IO with md raid
Date: Mon, 14 Dec 2009 12:06:08 +0300
Message-ID: <4B260000.3040703@matws.net>
References: <4B198DBA.5000906@matws.net> <4B1A6C28.20800@shiftmail.org>	<4B1D88D2.9000001@matws.net> <87hbs03y0t.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87hbs03y0t.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Goswin,
 > Software raid1 will write twice as much data. That means twice as much
 > data goes over the system bus and into the controler cache.
 > Effectively you have halve the cache size. Maybe that is all you see.
 >
 > MfG
 >          Goswin
 >
Your idea seems logical, and I took a few hours today to verify it and 
it's the case as accessing the disk without software raid leads to 
almost the same result as with hardware raid.

Matthieu.
