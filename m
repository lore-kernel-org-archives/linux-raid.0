From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is My Data DESTROYED?!
Date: Mon, 26 Oct 2009 18:21:49 -0500
Message-ID: <20091026232154764.YPHQ6016@cdptpa-omta03.mail.rr.com>
References: <EFC965352E0D46AE8F849753A9602B71@m5>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <EFC965352E0D46AE8F849753A9602B71@m5>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> } 	I rather like fbackup combined with gzip, but I don't know if there
> } is a Linux port of fbackup.  I use fbackup to create a named index for
> } each
> } backup set, whether on disk or tape.  This makes it easy to see if a
> } particular file is on an archive without having to load the archive.
> }
> 
> Where do you keep this index?  Hopefully not on the disk that needs to be
> restored.  :)

	That would be rather silly, although it can always be rebuilt from
the backup set itself.  No, the indices are all kept on the hard drive which
holds the most recent backups.  The tapes are taken off-premise.

