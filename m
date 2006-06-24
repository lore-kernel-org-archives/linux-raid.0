From: David Greaves <david@dgreaves.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Sat, 24 Jun 2006 10:34:13 +0100
Message-ID: <449D0715.8050609@dgreaves.com>
References: <449AEB7C.6040108@cjx.com>	<op.tblclqd3cigqcu@apollo13>	<fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com>	<449BE381.6070000@cjx.com>	<fd8d0180606230630x3f6b1ab7g444716cf8d5ab2c2@mail.gmail.com>	<68c491a60606230746m5c1f0301g8e00fdd4f0e0739b@mail.gmail.com>	<449C0505.8000601@tmr.com>	<fd8d0180606230834t18427168jd776d33980f516b2@mail.gmail.com> <17564.52087.651968.635043@cse.unsw.edu.au> <449CF0D0.9080006@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449CF0D0.9080006@comcast.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <talbotx@comcast.net>
Cc: Neil Brown <neilb@suse.de>, Francois Barre <francois.barre@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Adam Talbot wrote:
> OK, this topic I relay need to get in on.
> I have spent the last few week bench marking my new 1.2TB, 6 disk, RAID6
> array.
Very interesting. Thanks.

Did you get around to any 'tuning'.
Things like raid chunk size, external logs for xfs, blockdev readahead
on the underlying devices and the raid device?

David
