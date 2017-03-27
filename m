From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Re-assembling array after double device failure
Date: Mon, 27 Mar 2017 16:31:13 +0200
Message-ID: <20170327143113.GA19680@metamorpher.de>
References: <20170327133813.GQ4349@bitfolk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170327133813.GQ4349@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 27, 2017 at 01:38:13PM +0000, Andy Smith wrote:
> I'm fairly confident that the drives themselves are actually okay -
> nothing untoward in SMART data - so I'm not going to replace them at
> this stage.

You did not show any logs or SMART output. There is literally nothing 
in your mail that points at timeouts. If your confidence is based on 
the frequent "disk got kicked. must be timeouts!!1" mails on this list, 
then I wish you all the best. Praying works for some people, right...?

If you get two disks kicked, chances are something is seriously wrong.
If there is any doubt at all, and no backups exist, ddrescue both drives.
Better to make a copy you don't need than need a copy you didn't make.

Be very careful with mdadm --create. Defaults change over time and 
rescue systems might give you old mdadm versions, so you have to 
specify everything (metadata version, data offsets, ...).

Consider using overlays for experiments:

https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

(But not on faulty drives.)

Regards
Andreas Klauer
