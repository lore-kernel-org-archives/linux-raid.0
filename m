From: Mike Hardy <mhardy@h3c.com>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Fri, 04 Feb 2005 10:31:31 -0800
Message-ID: <4203BF83.4050408@h3c.com>
References: <200502031743.j13Hha910546@www.watkins-home.com> <42026860.1000409@zytor.com> <Pine.LNX.4.56.0502031822160.9028@lion.drogon.net> <200502040904.38264.andrew@walrond.org> <Pine.LNX.4.56.0502041031470.29133@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.56.0502041031470.29133@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Gordon Henderson wrote:

> I have had a private email from someone who has experienced similar
> lock-ups with twin Opteron systems and PCI cards, so from that point of
> view it doesn't bode well.
> 
> I have some quad Opterons running too, and they seem fine, although they
> are pure compute servers with just a local IDE drive. (and they are
> running SuSE 64-bit which is what the application demands)

Interesting - the private mail was from me, and I've got two dual 
Opterons in service. The one with significantly more PCI activity has 
significantly more problems then the one with less PCI activity.

There appears to be a trend here then, if 3 is a trend.

We're moving to a single PCI card (8-port 3ware, iirc) for all 
off-motherboard disk access, and I'll report back if that changes anything.

-Mike
