From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is My Data DESTROYED?!
Date: Sun, 25 Oct 2009 20:36:02 -0500
Message-ID: <20091026013607008.UDPS5890@cdptpa-omta01.mail.rr.com>
References: <54075B33AEE94E7E965ACB64C976007E@m5>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54075B33AEE94E7E965ACB64C976007E@m5>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Cool, I learned something.  Thanks.
> 
> I use disks too.  Could "seek" using dd, but I also gzip my stuff and use
> cpio.  :(  Anyway, I almost never need to restore a file.  :)

	I rather like fbackup combined with gzip, but I don't know if there
is a Linux port of fbackup.  I use fbackup to create a named index for each
backup set, whether on disk or tape.  This makes it easy to see if a
particular file is on an archive without having to load the archive.

