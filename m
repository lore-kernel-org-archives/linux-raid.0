From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5 code ok with 2TB + ?
Date: Sun, 28 Nov 2004 23:49:49 -0500
Message-ID: <200411290449.iAT4nsN02715@www.watkins-home.com>
References: <Pine.LNX.4.61.0411290033010.28142@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0411290033010.28142@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: 'Stephan van Hienen' <raid@a2000.nu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I use dd to test disks, and arrays.  Give this a test.  It may stop at the
2TB limit, not sure.  My monster 14 disk array is only about 240G.

time dd if=/dev/md0 of=/dev/null bs=1024k

I don't think badblocks would detect bad block on an array.  If one did
occur, the drive would be failed and the array would continue.  If your
re-sync finishes, that really does test your disks since every block used by
md is read or written.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Stephan van Hienen
Sent: Sunday, November 28, 2004 6:35 PM
To: linux-raid@vger.kernel.org
Subject: Re: raid5 code ok with 2TB + ?

On Sun, 28 Nov 2004, Stephan van Hienen wrote:

> now running a resync
> after that i'll run badblocks on it to test if i can read/write to the 
> complete array

resync finished without any problems
i wanted to run badblocks on the /dev/md0 to check
but it looks like badblocks doesn't support 2TB + :

]# badblocks -sw -p99 -c8192 /dev/md0
Writing pattern 0xaaaaaaaa:                    126464/-2009266944

any other hints for testing the raid ?

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

