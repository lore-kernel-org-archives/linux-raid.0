From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Fri, 7 Mar 2008 01:02:29 +0100
Message-ID: <20080307010229.7006ce0a@szpak>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
	<1204843956.2673.8.camel@vema.umeoce.maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1204843956.2673.8.camel@vema.umeoce.maine.edu>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Thu, 2008-03-06 at 16:08 -0500, Marc Bejarano wrote:
> > i've been doing burn-in on a new server i had hoped to deploy months 
> > ago and can't seem to figure out the cause of data corruption i've 
> > been seeing.  

long time ago I had such problems due to faulty IO controller.
Everytime I did md5sum on a big file (about 1GB) I got a different
result.

-- 
Janek Kozicki                                                         |
