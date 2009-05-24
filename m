From: Billy Crook <billycrook@gmail.com>
Subject: Re: Missing md superblock on added devices after grow ...
Date: Sun, 24 May 2009 13:06:40 -0500
Message-ID: <a43edf1b0905241106r7334f8ccr725d8f54ba18bf90@mail.gmail.com>
References: <200905231703.03692.denrdc@gmail.com> <16efced97de975092f941a9a626d6f0d.squirrel@neil.brown.name>
	<200905241815.20737.rob.vandermeulen@telenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200905241815.20737.rob.vandermeulen@telenet.be>
Sender: linux-raid-owner@vger.kernel.org
To: Rob Vandermeulen <rob.vandermeulen@telenet.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 24, 2009 at 11:15, Rob Vandermeulen
<rob.vandermeulen@telenet.be> wrote:
> I guess i really should be more carefull using mapper and real devices when
> changing partition layout.

If your partitioning tool doesn't automatically re-read the
partitioning layout (and it sounds like it didn't in this case), use
hdparm -z /dev/sda to re-read the partitions on sda.  parted usually
re-reads on its own.  And of course after doing the partitioning, and
before using the partitions as raid components, enumerate the drive
partitioning, and verify it is exactly as you expect:

parted /dev/sda print free
