From: Neil Brown <neilb@suse.de>
Subject: Re: maximum size
Date: Tue, 27 Sep 2005 15:31:43 +0200
Message-ID: <17209.18879.583532.761762@cse.unsw.edu.au>
References: <43394753.9040107@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Farkas Levente on Tuesday September 27
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@bppiac.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 27, lfarkas@bppiac.hu wrote:
> hi,
> i'd been already asked, but don't get any answer. what is the maximum 
> size of a raid5 and raid5 partition in kerenel 2.6? i try to find the 
> answer but found only kernel 2.4 info.
> thanks in advance.
> 

Providing you are using either 64bit hardware, or the 'LBD' (large
block device) config, then raid5 arrays can be up to 2^64 -
i.e. enormous - no practical limit.

I don't know what you mean by 'raid5 partition'.  If you mean like a
regular partition of a device, then the partition can be nearly as bit
as the array....

Component devices in a raid5 cannot be larger than 2 terabytes, but I
don't think you can buy devices that big yet.

NeilBrown
