From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 07:43:32 +0100
Message-ID: <20130128064332.4E502258985@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <5105D0EA.7080100@turmel.org> <6BCDA3B1-C137-486D-A45D-55912207AF3C@colorremedies.com> <2C80C970-FE4F-4CFE-8F40-48BE14F3140F@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <2C80C970-FE4F-4CFE-8F40-48BE14F3140F@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Phil Turmel <philip@turmel.org>, Brad Campbell <lists2009@fnarfbargle.com>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear Chris,

In message <2C80C970-FE4F-4CFE-8F40-48BE14F3140F@colorremedies.com> you wrote:
> 
> > The mismatch number is not divisible by 16, yet your chunk size is
> 16KB. It is divisible by 4 and 8, so I'm going to guess that the
> physical sector size is 4096 bytes. If correct, I'm coming up with a
> maximum of 346GiB worth of sectors may be adversely affected, assuming
> every sector in the mismatch count is bad (which is probably not true,
> but could be).
> 
> Since the upgrade to Fedora 18 for this particular RAID 6, can you
> estimate how much data has been written to the array? Could it be in the
> 90GiB to 350GiB range?

No.  Much less has been written.  But then, your calculation above is
wrong - these are 510 byte sector disks.

> man 4 md says the same, for raid 5 and 6, mismatches are not expected to
> be software problems, but much more likely hardware. But if it's true
> that the OP's problems started exactly with the upgrade to Fedora 18,
> that it could be a device driver. What HBA is being used?

Correct, the hardware has not been changed, and has been running fine
for many months before,

Two of the systems use a Marvell Technology Group Ltd. MV88SX6081
8-port SATA II PCI-X Controller; the third system uses a LSI Logic /
Symbios Logic SAS1068E PCI-Express Fusion-MPT SAS controller.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Human beings were created by water to transport it uphill.
