From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] 2.4.x Linux Medley RAID Version 7
Date: Wed, 10 Mar 2004 15:56:56 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <404F8118.1060203@pobox.com>
References: <200403101707.38595.bzolnier@elka.pw.edu.pl> <Pine.LNX.4.40.0403101917170.2582-100000@jehova.dsm.dk> <c2nv0b$j5$1@news.cistron.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <c2nv0b$j5$1@news.cistron.nl>
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Miquel van Smoorenburg wrote:
> MD already has support for more than one type of superblock. I think
> if you just add medley (or intel, or ..) support to MD you're all set.

Indeed.  Further, we have the new vendor-neutral RAID metadata format, 
"DDF", looming on the very near horizon.

I want to avoid having NN duplicated RAID0/1/5 engines, like ataraid in 
2.4 was threatening to be.

	Jeff
