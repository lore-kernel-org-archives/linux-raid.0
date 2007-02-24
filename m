From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: nonzero mismatch_cnt with no earlier error
Date: Sat, 24 Feb 2007 04:14:36 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702240413570.21012@p34.internal.lan>
References: <45DF859B.2050108@eyal.emu.id.au> <45DFE217.3020703@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45DFE217.3020703@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Perhaps,

The way it works (I believe is as follows)

1. echo check > sync_action
2. If mismatch_cnt > 0 then run:
3. echo repair > sync_action
4. Re-run #1
5. Check to make sure it is back to 0.

Justin.

On Sat, 24 Feb 2007, Eyal Lebedinsky wrote:

> I did a resync since, which ended up with the same mismatch_cnt of 184.
> I noticed that the count *was* reset to zero when the resync started,
> but ended up with 184 (same as after the check).
>
> I thought that the resync just calculates fresh parity and does not
> bother checking if it is different. So what does this final count mean?
>
> This leads me to ask: why bother doing a check if I will always run
> a resync after an error - better run a resync in the first place?
>
> -- 
> Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
> 	attach .zip as .dat
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
