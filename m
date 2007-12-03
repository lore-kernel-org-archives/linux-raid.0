From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Spontaneous rebuild
Date: Mon, 03 Dec 2007 13:15:37 +1300
Message-ID: <47534AA9.1000306@sauce.co.nz>
References: <475230AF.3010100@student.tuwien.ac.at> <18259.15453.811495.461016@notabene.brown> <Pine.LNX.4.64.0712021827100.13428@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712021827100.13428@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:

> While we are on the subject of bad blocks, is it possible to do what 
> 3ware raid controllers do without an external card?
> 
> They know when a block is bad and they remap it to another part of the 
> array etc, where as with software raid you never know this is happening 
> until the disk is dead.

Are you sure the 3ware software is remapping the bad blocks, or is it 
just reporting the bad blocks were remapped?

As I understand it, bad block remapping (reallocated sectors), are done 
internally at the drive level.

Perhaps all 3ware are doing is running the SMART command for reallocated 
sectors on all drives on a periodic basis and reporting any changes?

Regards,

Richard
