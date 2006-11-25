From: Nix <nix@esperi.org.uk>
Subject: Re: Linux RAID version question
Date: Sat, 25 Nov 2006 17:24:24 +0000
Message-ID: <87wt5jjv7b.fsf@hades.wkstn.nix>
References: <d33135570611231749p2d24eb51r7fc5a518afada0cd@mail.gmail.com>
	<87d57ciiu0.fsf@hades.wkstn.nix>
	<d33135570611241445k17c51ed2t511deb7b0e47e05f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d33135570611241445k17c51ed2t511deb7b0e47e05f@mail.gmail.com> (Dragan Marinkovic's message of "Fri, 24 Nov 2006 14:45:48 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Dragan Marinkovic <marinkovic.dragan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24 Nov 2006, Dragan Marinkovic said:
> If I wanted to make metadata version 1 as a default for RAID create,
> should I put metadata=1.x into the config file (e.g. /etc/mdadm.conf)
> or there is a different option to indicate the default?

You want

  CREATE metadata=1.0

(or whatever version you're using), I think. (I don't use that option
myself but that's what the source seems to say.)

-- 
`The main high-level difference between Emacs and (say) UNIX, Windows,
 or BeOS... is that Emacs boots quicker.' --- PdS
