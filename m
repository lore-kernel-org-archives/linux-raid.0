From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Hard drive Reliability?
Date: Mon, 24 May 2004 22:35:10 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40B2405E.8040801@wasp.net.au>
References: <Pine.LNX.4.44.0405200801180.19972-100000@coffee.psychology.mcmaster.ca> <006601c43e6e$edad2a90$180aa8c0@johnny> <33179.194.60.85.4.1085063918.squirrel@194.60.85.4> <40AEE1E1.8030603@wasp.net.au> <20040524132525.GA14721@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040524132525.GA14721@janus>
To: Frank van Maarseveen <frankvm@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Frank van Maarseveen wrote:
> On Sat, May 22, 2004 at 09:15:13AM +0400, Brad Campbell wrote:
> 
>>For those looking for great SATA hotswap bays with good cooling, I have 2 
>>of these. Besides being a bit on the noisy side, they keep the drives very 
>>cool and the added airflow inside the case keeps everything else cool too!
>>
>>http://www.supermicro.com/products/accessories/mobilerack/CSE-M35T-1.cfm
> 
> 
> I hope you didn't put a complete raid set in one of these because they
> have only one fan. Guess what happens when that moving part dies...

Yep, I have 2 units with 10 drives combined into a single Raid-5.

When that moving part dies the drives heat up a bit more. There are 4 case evacuation fans at the 
back of this box that provide just enough backup airflow to stop the drives reaching destruction 
temperatures.

I have had a good look at the failure modes of 92mm double ball bearing fans and I have not found 
much record of them failing catastrophically. They slow down due to dust or bearing failure over 
time before they grind to a halt usually.

These boxes measure fan RPM and drive temperature and if either of them get a little out of hand 
they sound a dirty great warning piezo that is hard to miss.

I'm not worried. I'm more concerened about psu/cpu fan failure than these fans failing.

Give me one decent 92mm double ball raced fan against multiple 40mm crappy sleeve fans you get in 
normal hotswap bays any day of the week!

Brad
