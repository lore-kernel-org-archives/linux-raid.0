From: Tejun Heo <tj@kernel.org>
Subject: Re: drivers/ata/libata-core.c:4732 ata_qc_issue+0x4c/0x2e0
Date: Tue, 09 Sep 2008 14:33:55 +0200
Message-ID: <48C66D33.5010507@kernel.org>
References: <20080909111643.GB6239@deprecation.cyrius.com> <48C661F8.5000709@kernel.org> <20080909121207.GB31147@uranium.pps.jussieu.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080909121207.GB31147@uranium.pps.jussieu.fr>
Sender: linux-ide-owner@vger.kernel.org
To: Pietro Abate <Pietro.Abate@pps.jussieu.fr>
Cc: Martin Michlmayr <tbm@cyrius.com>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Pietro Abate wrote:
> On Tue, Sep 09, 2008 at 01:46:00PM +0200, Tejun Heo wrote:
>> Martin Michlmayr wrote:
>>> A Debian user reported the following oops (2.6.26, RAID1 + LVM,
>>> running on an ARM platform, sata_mv):
>> Can you please attach full log?
> 
> Well, there you go :) and please don't tell me my disk are just gone banana...
> as I basically never used them ...

Okay, two things.

* sata_mv ->qc_defer bug is showing up as WARN_ON (the stack dump and
all).  Fix for this is in the tree and should appear in -stable soon.

* Your drive is going banana.  :-P

-- 
tejun
