From: "Erik Boettcher" <tehfoo@gmail.com>
Subject: Re: Raid 5 Recovery
Date: Sun, 28 Dec 2008 13:12:53 -0500
Message-ID: <125ed8800812281012x23b74839id19016f69854e623@mail.gmail.com>
References: <125ed8800812272221y44e77849l886a80f32cbcfbec@mail.gmail.com>
	 <3513de790812280753k5c46799cj92a0e9566227fadc@mail.gmail.com>
	 <125ed8800812281002t6eecb5cbu2173efab36418c92@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <125ed8800812281002t6eecb5cbu2173efab36418c92@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

---------- Forwarded message ----------
From: Erik Boettcher <tehfoo@gmail.com>
Date: Sun, Dec 28, 2008 at 1:02 PM
Subject: Re: Raid 5 Recovery
To: Dylan Distasio <interzone@gmail.com>


On Sun, Dec 28, 2008 at 10:53 AM, Dylan Distasio <interzone@gmail.com> wrote:
> Have you tried assembling the array degraded to see if you can force
> it without sdd3?  I don't know if this is the best solution, but if
> that works, you can then readd sdd3 and have the array rebuild.

I tried forcing the assembly without sdd3, and it complains about sde3!

I find it interesting that before the first command sdc3 failed but
now it's not the fault point....
