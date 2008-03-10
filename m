From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Mon, 10 Mar 2008 20:02:25 +0100
Message-ID: <20080310200225.1b9914e3@szpak>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
	<1204848652.3062.100.camel@localhost.localdomain>
	<200803101519.m2AFJCJS032509@colby.verdasys.com>
	<1205163386.2941.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1205163386.2941.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

James Bottomley said:     (by the date of Mon, 10 Mar 2008 10:36:26 -0500)


> I'm afraid the only way to confirm this theory definitively will be with
> the destructive disktest

you can try this destructive test:

  badblocks -c 10240 -s -w -t random -v /dev/sdc

or use smaller value for -c if you wish.

-- 
Janek Kozicki                                                         |
