From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: To LVM, or not LVM ?
Date: Mon, 15 Nov 2004 03:11:36 -0500
Message-ID: <200411150811.iAF8BfN18879@www.watkins-home.com>
References: <6F9171BE257CA742BFBCFA87B8F20F8D030E3EAB@NZURC900PEX1.ubsgs.ubsgroup.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6F9171BE257CA742BFBCFA87B8F20F8D030E3EAB@NZURC900PEX1.ubsgs.ubsgroup.net>
Sender: linux-raid-owner@vger.kernel.org
To: peter.greis@ubs.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Are you going to create 1 big logical volume?

If so, I see no need.
But if you will be creating more than 1 logical volume, then go for it.  It
would be less work to maintain 1 array, instead of many.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of peter.greis@ubs.com
Sent: Monday, November 15, 2004 3:04 AM
To: linux-raid@vger.kernel.org
Subject: To LVM, or not LVM ?

Greetings All,

I have a SuSE 9.1 server which I am getting ready to stuff 4 SATA drives
into for extra storage (SIL controller onboard). Using 300GB disks with
RAID5, this should give me 900GB of usable space, yes ? Anyway, I appeal to
the list - should I build the array with LVM or not ? Any disadvantages ?

regards,

-Peter
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

