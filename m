From: Neil Brown <neilb@suse.de>
Subject: Re: When does a disk get flagged as bad?
Date: Thu, 31 May 2007 16:10:33 +1000
Message-ID: <18014.26329.836246.525012@notabene.brown>
References: <5822.1180578498@mdt.dhcp.pit.laurelnetworks.com>
	<1180579742.20508.18.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alberto Alonso on Wednesday May 30
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 30, alberto@ggsys.net wrote:
> 
> After thinking about your post, I guess I can see some logic behind
> not failing on the read, although I would say that after x amount of
> read failures a drive should be kicked out no matter what.

When md gets a read error, it collects the correct data from elsewhere
and tries to write it to the drive that apparently failed.
If that succeeds, it tries to read it back again.  If that succeeds as
well, it assumes that the problem has been fixed.  Otherwise it fails
the drive.


NeilBrown
