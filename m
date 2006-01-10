From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.15-mm3 sata_mv / raid 5 array start failure on boot
Date: Tue, 10 Jan 2006 12:30:42 +1100
Message-ID: <17347.3650.415581.4115@cse.unsw.edu.au>
References: <43B82DDE.3060509@projecthugo.co.uk>
	<43BA9A24.7030002@projecthugo.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Matt Darcy on Tuesday January 3
Sender: linux-raid-owner@vger.kernel.org
To: kernel-lists@projecthugo.co.uk
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 3, kernel-lists@projecthugo.co.uk wrote:
> 
> I re-created the array - and took a dump of the raid config
> 
> ARRAY /dev/md6 level=raid5 num-devices=6 spares=1 
> UUID=f92fa512:1fe54278:d3ba820f:cecb842a

You'll need a 'DEVICES' line in the mdadm.conf for it to work.

NeilBrown
