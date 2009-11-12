From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 22:55:47 -0600
Message-ID: <20091112045600054.OQVX5263@cdptpa-omta04.mail.rr.com>
References: <4AFB660C.8000405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFB660C.8000405@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Doug Ledford' <dledford@redhat.com>
Cc: 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> >     Data Offset : 272 sectors
> >    Super Offset : 8 sectors
> 
> The above two items are what you need for both version 1.1 and 1.2
> superblocks in order to figure things out.  The data, aka the filesystem
> itself, starts at the Data Offset which is 272 sectors.  The superblock
> itself is 8 sectors in from the front of the disk because you have
> version 1.2 superblocks.  So, 272 - 8 - size of the superblock, which is
> only a sector or two, is how much internal space you have.  So, in your
> case, you have about 132k of space for the bitmap.

	OK.  The 10 drive system shows:

bitmap: 0/466 pages [0KB], 1024KB chunk

	The 7 drive system shows:

bitmap: 0/350 pages [0KB], 2048KB chunk

So you think I should remove both and replace them with 

mdadm -G /dev/md0 --bitmap=internal --bitmap-chunk=65536

?

	While most of the files are large video files, there are a fair
number which are smaller data files such as those of the IMAP server and
Quicken.  I don't want performance to be too terrible for them, either.


