From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Why does one get mismatches?
Date: Tue, 2 Mar 2010 19:52:16 +0100
Message-ID: <20100302185216.GB2243@lazy.lzy>
References: <20100218100547.7aecdc34@notabene.brown>
 <4B853BBF.7000607@tmr.com>
 <yq1ocjemx46.fsf@sermon.lab.mkp.net>
 <20100225083936.07cd48ad@notabene.brown>
 <20100228080949.GA30574@maude.comedia.it>
 <20100302160100.621f9811@notabene.brown>
 <20100302073624.GA28827@maude.comedia.it>
 <4877c76c1003020204r477e942fo8ada66e1e9426295@mail.gmail.com>
 <20100302110232.GA14131@maude.comedia.it>
 <4B8D5581.8070509@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B8D5581.8070509@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> Now it would be interesting to understand why the mismatches don't
> happen when LVM is above MD-raid!?

well, maybe LVM copies the buffer, and after it
plays it nice with MD, i.e. no changes on the fly.

Or maybe, it is just one system that behaves
properly with LVM over MD.

bye,

-- 

piergiorgio
