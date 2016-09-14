From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: moving spares into group and checking spares
Date: Wed, 14 Sep 2016 19:35:30 +0100
Message-ID: <57D99872.3000802@youngman.org.uk>
References: <nramjg$n07$1@blaine.gmane.org>
 <20160914092959.GA3584@metamorpher.de> <nrc2pm$2a9$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <nrc2pm$2a9$1@blaine.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: scar <scar@drigon.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/09/16 18:52, scar wrote:
> i'm not sure what you're suggesting, that 4x 11+1 RAID5 arrays should be
> changed to 1x 46+2 RAID6 array?  that doesn't seem as safe to me.  and
> checkarray isn't going to check the spare disks just as it's not doing
> now.... also that would require me to backup/restore the data so i can
> create a new array

No. The suggestion is to convert your 4x 11+1 raid5's to 4x 12 raid6's.
(or do you mean 11 drives plus 1 parity? If that's the case I mean 11
plus 2 parity)

That way you're using all the drives, they all get tested, and if a
drive fails, you're left with a degraded raid6 aka raid5 aka redundant
array. With your current setup, if a drive fails you're left with a
degraded raid5 aka raid0 aka a "disaster in waiting".

And then you can add just the one spare disk to a spares group, so if
any drive does fail, it will get rebuilt straight away.

The only problem I can see (and I should warn you) is that there seems
to be a little "upgrading in place" problem at the moment. My gut
feeling is it's down to some interaction with systemd, so if you're not
running systemd I hope it won't bite ...

Cheers,
Wol
