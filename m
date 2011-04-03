From: NeilBrown <neilb@suse.de>
Subject: Re: Raid 5 Array
Date: Sun, 3 Apr 2011 17:49:00 +1000
Message-ID: <20110403174900.38de17e2@notabene.brown>
References: <BANLkTim8620MUckc+EVCWo9FCTs=65_p8Q@mail.gmail.com>
	<4D977279.30107@gmail.com>
	<BANLkTimJfUhvkpkkAH=NLJOvLL-Jotrwqg@mail.gmail.com>
	<4D97828C.8050806@gmail.com>
	<6158157523854459259@unknownmsgid>
	<20110403040113.472838d4@natsu>
	<AANLkTikJtFb0JtS1-Je9NFXn-CRc4pi7pmYFNV7v2SEg@mail.gmail.com>
	<BANLkTi=wWAE79KOPhZ0OUWpicgcD7QNG-g@mail.gmail.com>
	<BANLkTimRSmSu2XOfQ8yUxn5r2Tsq53LCmQ@mail.gmail.com>
	<BANLkTikQai-ZwuEDQDinMcYi4ics_axd7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikQai-ZwuEDQDinMcYi4ics_axd7Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus <nexuslite@gmail.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, Roman Mamedov <rm@romanrm.ru>, Simon Mcnair <simonmcnair@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 2 Apr 2011 23:41:50 -0700 Marcus <nexuslite@gmail.com> wrote:

> Okay I have my raid extended to 1500.3GB however I can't seem to grow
> the partition past 1TB. It will let me create a new partition but it
> won't let me make the current partition any bigger. Does anyone know
> how to fix this?

Best to show exactly the command you use, exactly the results, and details
about the component devices (particularly size).
When using any mdadm command, add "-vv" to make it as verbose as possible.
Include kernel log messages (e.g. dmesg | tail -100)

Prefer to send too much info rather than not enough.
And just place it in-line in the email, no attachments, not 'pastebin' links.

NeilBrown
