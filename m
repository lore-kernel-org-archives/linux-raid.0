From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: i just read in the archive.........
Date: Fri, 14 Jun 2002 20:00:23 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15625.48823.906206.332483@notabene.cse.unsw.edu.au>
References: <1024044823.2250.15.camel@Asterix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from =?ISO-8859-1?Q?Lo=EFc?= Paillotin on  June 14
To: =?ISO-8859-1?Q?Lo=EFc?= Paillotin <loic.paillotin@qualimucho.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> I justy read in the archive that software raid would'nt work with ext3
> file system. Is that true ? ( i mean is that still true? )

This sounds like a 2.2 kernel comment.  There were issues in 2.2.  The
same issues now longer exist in 2.4.

There have been some ext3 issues (that are only related to raid by
coincidence) lately.  I'm not sure if they have all been fixed in an
official release yet.  I know I can get file corruption with 0.9.18 if
I am using data=journal.  With other data modes 0.9.18 should be fine
(in www.{country}.kernel.org/pub/linux/kernel/people/sct/....)

NeilBrown
