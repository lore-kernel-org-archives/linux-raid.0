From: NeilBrown <neilb@suse.de>
Subject: Re: Growing a RAID array
Date: Fri, 13 May 2011 11:23:13 +1000
Message-ID: <20110513112313.54fbb717@notabene.brown>
References: <28.92.03893.3038CCD4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <28.92.03893.3038CCD4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 12 May 2011 20:02:01 -0500 "Leslie Rhorer" <lrhorer@satx.rr.com>
wrote:

> 
> 	I am shortly going to be growing a 10 drive RAID6 array with two
> additional drives.  Can this be done in a single grow operation by setting
> n=12, or do I have to grow it 1 drive at a time?
> 

Experiment with loop-back devices created on modest sized files.


(but yes, you can grow by any number you like.  You should test the drives
fairly heavily first, because if they both die during the reshape, you lose
your data).

NeilBrown
