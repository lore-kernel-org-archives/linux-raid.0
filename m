From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: raid failure question
Date: Mon, 11 Jan 2010 22:47:07 -0600
Message-ID: <3B.02.19578.1DEFB4B4@cdptpa-omtalb.mail.rr.com>
References: <1263232840.8962.193.camel@kije>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1263232840.8962.193.camel@kije>
Sender: linux-raid-owner@vger.kernel.org
To: 'Tim Bock' <jtbock@daylight.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Tim Bock
> Sent: Monday, January 11, 2010 12:01 PM
> To: linux-raid@vger.kernel.org
> Subject: raid failure question
> 
> Hello,
> 
> Excluding the obvious multi-disk or bus failures, can anyone describe
> what type of disk failure a raid cannot detect/recover from?
> 
> I have had two disk failures over the last three months, and in spite of
> having a hot spare, manual intervention was required each time to make
> the raid usable again.  I'm just not sure if I'm not setting something
> up right, or if there is some other issue.

	I think you are trying to ask two different questions, here.  The
first concerns errors which make an array unrecoverable without intervention
by an admin.  The second concerns not promoting a hot standby whenever a
drive is failed by the array, even though the array itself is automatically
recoverable.

