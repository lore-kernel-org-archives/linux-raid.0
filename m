From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: mismatch_cnt of 128 and 1408.
Date: Tue, 25 Mar 2008 13:43:36 +0100
Message-ID: <20080325134336.31e392f6@absurd>
References: <20080324083651.444cbab3@absurd>
	<18408.29345.627523.525932@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18408.29345.627523.525932@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown said:     (by the date of Tue, 25 Mar 2008 14:33:53 +1100)

> I recommend
>   echo repair > /sys/block/md0/md/sync_action
> That will fix it.

great, thanks. It worked :-)

-- 
Janek Kozicki                                                         |
