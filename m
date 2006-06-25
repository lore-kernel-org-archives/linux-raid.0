From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Sun, 25 Jun 2006 09:06:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0606250905160.25559@chaos.egr.duke.edu>
References: <449AEB7C.6040108@cjx.com> <op.tblclqd3cigqcu@apollo13>
 <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com> <449BE381.6070000@cjx.com>
 <fd8d0180606230630x3f6b1ab7g444716cf8d5ab2c2@mail.gmail.com>
 <68c491a60606230746m5c1f0301g8e00fdd4f0e0739b@mail.gmail.com>
 <449C0505.8000601@tmr.com> <fd8d0180606230834t18427168jd776d33980f516b2@mail.gmail.com>
 <17564.52087.651968.635043@cse.unsw.edu.au> <449CF0D0.9080006@comcast.net>
 <449D0715.8050609@dgreaves.com> <449DC23E.4000604@comcast.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449DC23E.4000604@comcast.net>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <talbotx@comcast.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 24 Jun 2006 at 3:52pm, Adam Talbot wrote

> nas tmp # time tar cf - . | (cd /data ; tar xf - )

A (bit) cleaner way to accomplish the same thing:

tar cf - --totals . | tar xC /data -f -

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
