From: Neil Brown <neilb@suse.de>
Subject: Re: Live Read Error Correction W/O Reconstruct?
Date: Tue, 24 Jan 2006 15:21:20 +1100
Message-ID: <17365.43840.355844.214204@cse.unsw.edu.au>
References: <20060124041452.68243.qmail@web35804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from mdw1103 on Monday January 23
Sender: linux-raid-owner@vger.kernel.org
To: mdw1103 <mdw1103@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 23, mdw1103@yahoo.com wrote:
> In 2004, Mr Brown wrote that read errors could be
> handled without reconstruction. Has this been
> implemented in 2.6.8? As I understand it,  this is the
> way RAID is supposed to work.
> 

Not in 2.6.8.
It is implemented in 2.6.15 for raid5 and 
2.6.16-rc1 for raid1 and raid6.

NeilBrown
