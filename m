From: Massimiliano Masserelli <negro@interim.it>
Subject: Re: RAID1 root - troubles booting in degraded mode
Date: Wed, 30 Oct 2002 12:10:44 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021030111044.GA5337@sgabanaz.interim.it>
References: <4D618F6493CE064A844A5D496733D66703142F@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D618F6493CE064A844A5D496733D66703142F@freedom.icomedias.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 30, 2002 at 11:52:25AM +0100, Martin Bene wrote:

> This look like you're initializing the array from an initrd using
> raidstart.

Indeed I am.

> Reason why it's not working: raidstart is stupid. it just reads the
> first device from raidtab and tries to read the raid superblock from
> there. if the first device listed in raidtab doesn't work, raidstart
> can't start the array.

Pity I didn't find this little detail in any of the docu I found and
read... Thank you very very much for the hint, I'll make some
experiments (static raid support vs. mdadm).

Bye.
-- 
Massimiliano Masserelli
-------------------------------------------------------------------------------
Nella sua prima passione la donna ama il suo amante,
in tutte le altre cio` che ama e` il suo amore.
    	-- Byron, "Don Juan"
