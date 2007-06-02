From: Alberto Alonso <alberto@ggsys.net>
Subject: Re: When does a disk get flagged as bad?
Date: Sat, 02 Jun 2007 10:50:41 -0500
Message-ID: <1180799441.20508.72.camel@w100>
References: <5822.1180578498@mdt.dhcp.pit.laurelnetworks.com>
	 <1180579742.20508.18.camel@w100> <18014.26329.836246.525012@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18014.26329.836246.525012@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So, what kind of error is:

end_request: I/O error, dev sdb, sector 42644555
end_request: I/O error, dev sdb, sector 124365763
...

I am still trying to figure out why that just make one of my servers
unresponsive.

Is there a way to have the md code kick that drive out of the array? 

The datacenter people are starting to get impatient having to reboot 
it every other day.

Thanks,

Alberto

On Thu, 2007-05-31 at 16:10 +1000, Neil Brown wrote:
> On Wednesday May 30, alberto@ggsys.net wrote:
> > 
> > After thinking about your post, I guess I can see some logic behind
> > not failing on the read, although I would say that after x amount of
> > read failures a drive should be kicked out no matter what.
> 
> When md gets a read error, it collects the correct data from elsewhere
> and tries to write it to the drive that apparently failed.
> If that succeeds, it tries to read it back again.  If that succeeds as
> well, it assumes that the problem has been fixed.  Otherwise it fails
> the drive.
> 
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Alberto Alonso                        Global Gate Systems LLC.
(512) 351-7233                        http://www.ggsys.net
Hardware, consulting, sysadmin, monitoring and remote backups

