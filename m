From: Mike Tran <mhtran@us.ibm.com>
Subject: RE: raid and sleeping bad sectors
Date: 29 Jun 2004 17:20:16 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1088547616.5376.124.camel@star2.austin.ibm.com>
References: <200406292151.i5TLpW325996@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200406292151.i5TLpW325996@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2004-06-29 at 16:51, Guy wrote:
> But!!!
> Most disks, if not all, already re-map bad blocks on write.  So, how will
> EVMS help?  The disk can't do anything about a read error!  Only a redundant
> system like md or a hardware raid can fix a read error.
> 
> Guy

Think of BBR as "addition" to hardware bad block relocation :)

Mike T.

