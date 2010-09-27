From: "Carl-=?ISO-8859-1?Q?Johan_W=E4gner?=" <carl-johan.wagner@agusta.se>
Subject: Re: RAID 5 with bad blocks
Date: Mon, 27 Sep 2010 17:43:23 +0200
Message-ID: <20100926232102.M67000@agusta.se>
References: <20100925000351.M29572@agusta.se>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100925000351.M29572@agusta.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: fafler@gmail.com
List-Id: linux-raid.ids

A follow up on my suggestion:
> Would it be possible to copy (with 'dd') the device (/dev/sdb) with sector
> errors to a fourth disk (/dev/sde) and then remove the faulty sdb-
> drive and reposition the newly copied sde to sdb's position to have 
> this act as the first sdb-drive, now working without any physical 
> faults, even if the data is incomplete in sectors; and now being 
> possible to recover the third drive (/dev/sdd1)?
'dd' is NOT the program one would want to use for this task.
"ddrescue" is the one!
NB: dd_rescue is not the same program, and may or may not work. Just note that
"apt-get install ddrescue" installs dd_rescue, not ddrescue...
ddrescue is downloaded (with e g curl) from:
# curl ftp.gnu.org/gnu/ddrescue/ddrescue-1.13.tar.gz >ddrescue-1.13.tar.gz

Having installed, copied disk to disk and swapped disks the RAID started ti
rebuild /dev/sdd1 and I have now a clean array again!


