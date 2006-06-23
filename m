From: Nix <nix@esperi.org.uk>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Fri, 23 Jun 2006 20:53:04 +0100
Message-ID: <87irmrk5sv.fsf@hades.wkstn.nix>
References: <449AEB7C.6040108@cjx.com>
	<fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com>
	<449BE381.6070000@cjx.com> <200606231701.44803.a1426z@gawab.com>
	<20060623160602.GK5817@schatzie.adilger.int> <449C19BF.7060500@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <449C19BF.7060500@gmx.de> (Christian Pedaschus's message of "23 Jun 2006 17:43:25 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christian Pedaschus <cpedaschus@gmx.de>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On 23 Jun 2006, Christian Pedaschus said:
> and my main points for using ext3 is still: "it's a very mature fs,
> nobody will tell you such horrible storys about data-lossage with ext3
> than with any other filesystem."

Actually I can, but it required bad RAM *and* a broken disk controller
*and* an electrical storm *and* heavy disk loads (only read loads,
but I didn't have noatime active so read implied write).

In my personal experience it's since weathered machines with `only' RAM
so bad that md5sums of 512Kb files wouldn't come out the same way twice
with no problems at all (some file data got corrupted, unsurprisingly,
but the metadata was fine).

Definitely an FS to be relied upon.

-- 
`NB: Anyone suggesting that we should say "Tibibytes" instead of
 Terabytes there will be hunted down and brutally slain.
 That is all.' --- Matthew Wilcox
