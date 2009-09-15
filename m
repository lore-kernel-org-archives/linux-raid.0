From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Tue, 15 Sep 2009 10:48:43 +0000 (UTC)
Message-ID: <h8nreb$n8p$4@ger.gmane.org>
References: <h8nbt5$n8p$1@ger.gmane.org>
	<alpine.LFD.2.00.0909150810510.5083@sbhezbfg.of5.nffheflf.cev>
	<h8nfoe$n8p$3@ger.gmane.org>
	<alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 15 Sep 2009 08:37:52 +0100, Alex Butcher wrote:

> Either way, it's not
> suitable for data I even care a little bit about.

Ordinarily I'd agree with you. In this case, however, the data is mostly 
read-only and on backup media. So I don't really care if the disks fall 
off the edge of a cliff; the data will survive.

I can justify a moderate amount of time working on this, with the 
hardware I have. I can't really justify buying eight new disks.

NB: Please don't dismiss this kind of setup out of hand. I know that 
disks are cheap enough these days that the typical professional user 
won't ever need to worry about not being able to replace hardware which 
behaves like this. However, many people happen to be in a different 
situation. :-/

-- 
Matthias Urlichs

