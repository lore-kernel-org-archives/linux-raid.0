From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: MD devices renaming or re-ordering question
Date: Fri, 14 Sep 2007 02:38:22 +0200
Message-ID: <87lkba5bep.fsf@informatik.uni-tuebingen.de>
References: <46E984E7.1080903@harddata.com>
	<87odg61ff7.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87odg61ff7.fsf@informatik.uni-tuebingen.de> (Goswin von
	Brederlow's message of "Thu, 13 Sep 2007 22:25:16 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Maurice Hilarius <maurice@harddata.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de> writes:

> The simplest is to pull the disks from md1 from the first controler
> and put them into the 2nd controler and then add the new disks to the
> first controler.

That is of cause whith the raid stoped. You didn't say what kind of
raid you have but while it is online it would need resyncing or would
just plain break if you hot-plug a disk.

MfG
        Goswin
