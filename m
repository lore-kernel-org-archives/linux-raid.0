From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Problem with multipath in 2.6.x kernel
Date: Tue, 15 Jun 2004 09:44:04 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16590.14404.98110.336368@cse.unsw.edu.au>
References: <D18A13F01D850B409793C6C3FA5E038917E127@SRVRE02.rdm.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Uher Marek on Monday June 14
To: Uher Marek <Marek.Uher@t-mobile.cz>
Cc: linux-raid@vger.kernel.org, christophe.varoqui@free.fr
List-Id: linux-raid.ids

On Monday June 14, Marek.Uher@t-mobile.cz wrote:
> 4) Activating an existing multipath device:
> 
> 	raidstart /dev/md0
> 

Don't use raidstart.  There is a reason that it says:

>    Syslog:
> 
> 	md: raidstart(pid 1866) used deprecated START_ARRAY ioctl. This will not be supported beyond 2.6

that it is deprecated.  Use:

  mdadm --assemble /dev/md0 --uuid=1611fd4d:f42482f8:49143747:eee27eff /dev/scsi/*/*/*/*/*

NeilBrown
